RSpec.describe SIADE::V2::Requests::Generic do
  subject { described_class.new }

  let(:provider_name) { 'INSEE' }

  before do
    allow_any_instance_of(described_class).to receive(:provider_name).and_return provider_name
  end

  describe 'monitoring service' do
    before do
      allow_any_instance_of(described_class).to receive(:valid?).and_return true
      allow_any_instance_of(described_class).to receive(:call_api).and_return nil
      allow_any_instance_of(described_class).to receive(:http_code).and_return 200
    end

    it 'sets provider name' do
      expect(MonitoringService.instance).to receive(:set_provider).with(
        provider_name
      )

      subject.perform
    end
  end

  describe 'errors from http client' do
    subject { described_class.new.perform }

    let(:valid_uri) { URI('http://www.google.fr') }

    before do
      allow_any_instance_of(described_class).to receive(:valid?).and_return true
      allow_any_instance_of(described_class).to receive(:request_uri).and_return valid_uri
      allow_any_instance_of(described_class).to receive(:request_params).and_return({})
      allow_any_instance_of(described_class).to receive(:response_wrapper).and_return SIADE::V2::Responses::Generic
      allow_any_instance_of(SIADE::V2::Responses::Generic).to receive(:adapt_raw_response_code)
    end

    describe 'with RestClient' do
      before do
        allow_any_instance_of(described_class).to receive(:request_lib).and_return :rest_client
        allow_any_instance_of(described_class).to receive(:request_verb).and_return :get
        allow_any_instance_of(described_class).to receive(:rest_client_options).and_return({})
      end

      context 'for RestClient::InternalServerError (500)' do
        before do
          allow_any_instance_of(RestClient::Resource).to receive(:get).and_raise(RestClient::InternalServerError)
        end

        its(:http_code) { is_expected.to eq 502 }
        its(:response) { is_expected.to be_a SIADE::V2::Responses::InternalServerError }

        it 'tracks provider error in monitoring service' do
          expect(MonitoringService.instance).to receive(:track_provider_error_from_response).with(
            an_instance_of(SIADE::V2::Responses::InternalServerError),
            anything
          )

          subject
        end
      end

      context 'for RestClient::ServerBrokeConnection (network error)' do
        before do
          allow_any_instance_of(RestClient::Resource).to receive(:get).and_raise(RestClient::ServerBrokeConnection)
        end

        its(:http_code) { is_expected.to eq 502 }
        its(:response) { is_expected.to be_a SIADE::V2::Responses::InternalServerError }

        it 'tracks provider error in monitoring service' do
          expect(MonitoringService.instance).to receive(:track_provider_error_from_response).with(
            an_instance_of(SIADE::V2::Responses::InternalServerError),
            anything
          )

          subject
        end
      end

      context 'for RestClient::Forbidden (403)' do
        before do
          allow_any_instance_of(RestClient::Resource).to receive(:get).and_raise(RestClient::Forbidden)
        end

        its(:http_code) { is_expected.to eq 502 }
        its(:response) { is_expected.to be_a SIADE::V2::Responses::UnexpectedError }

        it 'logs as error this unexpected behaviour, with exception backtrace' do
          expect(MonitoringService.instance).to receive(:track).with(
            'error',
            anything,
            {
              provider_name:,
              exception_backtrace: anything,
            }
          )

          subject
        end
      end

      context 'for RestClient::TimeoutError' do
        before do
          allow_any_instance_of(RestClient::Resource).to receive(:get).and_raise(RestClient::RequestTimeout)

          subject.perform
        end

        its(:http_code) { is_expected.to eq(504) }
        its(:response) { is_expected.to be_a(SIADE::V2::Responses::TimeoutError) }
      end

      context 'for an unexpected http error code' do
        before do
          stub_request(:get, valid_uri.to_s).to_return(
            status: 506,
            body: 'PANIK'
          )
        end

        it 'logs as error this unexpected behaviour, with exception backtrace' do
          expect(MonitoringService.instance).to receive(:track).with(
            'error',
            anything,
            {
              provider_name:,
              exception_backtrace: anything,
            }
          )

          subject
        end

        its(:http_code) { is_expected.to eq 502 }
        its(:response) { is_expected.to be_a SIADE::V2::Responses::UnexpectedError }
      end
    end

    describe 'with Net::HTTP' do
      before do
        allow_any_instance_of(described_class).to receive(:request_lib).and_return :net_http
        allow_any_instance_of(described_class).to receive(:request_verb).and_return :get
        allow_any_instance_of(described_class).to receive(:net_http_options).and_return({})
      end

      context 'for Net::OpenTimeout (408)' do
        before do
          stub_request(:get, valid_uri.to_s).to_timeout
        end

        its(:http_code) { is_expected.to eq 504 }
        its(:response) { is_expected.to be_a SIADE::V2::Responses::TimeoutError }
      end

      context 'for Net::HTTPGatewayTimeout (504)' do
        before do
          stub_request(:get, valid_uri.to_s).to_return(
            status: 504
          )
        end

        its(:http_code) { is_expected.to eq 504 }
        its(:response) { is_expected.to be_a SIADE::V2::Responses::TimeoutError }
      end

      context 'for Net::HTTPServiceUnavailable (503)' do
        before do
          stub_request(:get, valid_uri.to_s).to_return(
            status: 503,
          )
        end

        its(:http_code) { is_expected.to eq 502 }
        its(:response) { is_expected.to be_a SIADE::V2::Responses::ServiceUnavailable }
      end

      context 'for Net::HTTPBadGateway (502)' do
        before do
          stub_request(:get, valid_uri.to_s).to_return(
            status: 502,
          )
        end

        its(:http_code) { is_expected.to eq 502 }
        its(:response) { is_expected.to be_a SIADE::V2::Responses::ServiceUnavailable }
      end

      context 'for Net::HTTPTooManyRequests (429)' do
        before do
          stub_request(:get, valid_uri.to_s).to_return(
            status: 429,
          )
        end

        its(:http_code) { is_expected.to eq 502 }
        its(:response) { is_expected.to be_a SIADE::V2::Responses::ServiceUnavailable }
      end


      context 'for Net::HTTPBadRequest (400)' do
        before do
          stub_request(:get, valid_uri.to_s).to_return(
            status: 400
          )
        end

        its(:http_code) { is_expected.to eq 502 }
        its(:response) { is_expected.to be_a SIADE::V2::Responses::UnexpectedBadRequest }

        it 'logs as error this unexpected behaviour' do
          expect_any_instance_of(MonitoringService).to receive(:track_provider_error_from_response).with(
            instance_of(SIADE::V2::Responses::UnexpectedBadRequest),
            anything
          )

          subject
        end

        its(:http_code) { is_expected.to eq 502 }
        its(:response) { is_expected.to be_a SIADE::V2::Responses::UnexpectedBadRequest }
      end

      context 'for Net::HTTPMovedPermanently (301)' do
        before do
          stub_request(:get, valid_uri.to_s).to_return(
            status: 301
          )
        end

        it 'logs as error this unexpected behaviour' do
          expect_any_instance_of(MonitoringService).to receive(:track_provider_error_from_response).with(
            instance_of(SIADE::V2::Responses::UnexpectedRedirection),
            anything
          )

          subject
        end

        its(:http_code) { is_expected.to eq 502 }
        its(:response) { is_expected.to be_a SIADE::V2::Responses::UnexpectedRedirection }
      end

      context 'for an unexpected http error code' do
        before do
          stub_request(:get, valid_uri.to_s).to_return(
            status: 506,
            body: 'PANIK'
          )
        end

        it 'logs as error this unexpected behaviour, with status and body' do
          expect(MonitoringService.instance).to receive(:track).with(
            'error',
            anything,
            {
              provider_name:,
              net_http_error_status: '506',
              net_http_error_body: 'PANIK',
            }
          )

          subject
        end

        its(:http_code) { is_expected.to eq 502 }
        its(:response) { is_expected.to be_a SIADE::V2::Responses::UnexpectedError }
      end

      context 'for an OpenSSL error' do
        let(:openssl_error) { OpenSSL::SSL::SSLError.new(ssl_error_message) }

        before do
          stub_request(:get, valid_uri.to_s).to_raise(openssl_error)
        end

        context 'when it is a "SSLv3/TLS write client hello" error' do
          let(:ssl_error_message) { 'SSL_connect SYSCALL returned=5 errno=0 SSLv3/TLS write client hello' }

          it 'logs as error this unexpected behaviour, with exception backtrace' do
            expect(MonitoringService.instance).to receive(:track).with(
              'error',
              anything,
              {
                provider_name:,
                exception_backtrace: anything,
              }
            )

            subject
          end

          its(:http_code) { is_expected.to eq 502 }
          its(:response) { is_expected.to be_a SIADE::V2::Responses::UnexpectedError }
        end

        context 'when it is an another error' do
          let(:ssl_error_message) { 'whatever' }

          it 'raises this error' do
            expect do
              subject
            end.to raise_error(OpenSSL::SSL::SSLError)
          end
        end
      end

      context 'for a SocketError' do
        let(:socket_error) { SocketError.new(socker_error_message) }

        before do
          stub_request(:get, valid_uri.to_s).to_raise(socket_error)
        end

        [
          'getaddrinfo: nodename nor servname provided, or not known',
          'getaddrinfo: No address associated with hostname',
          'getaddrinfo: Name or service not known',
          'getaddrinfo: Temporary failure in name resolution'
        ].each do |dns_error_message|
          context 'for a DNS resolution fail (no address associated)' do
            let(:socker_error_message) { "Failed to open TCP connection to www.google.com:443 (#{dns_error_message})" }

            it 'logs as error the dns lookup fail' do
              expect_any_instance_of(MonitoringService).to receive(:track_provider_error_from_response).with(
                instance_of(SIADE::V2::Responses::DnsResolutionError),
                anything
              )

              subject
            end

            its(:http_code) { is_expected.to eq 502 }
            its(:response) { is_expected.to be_a SIADE::V2::Responses::DnsResolutionError }
          end
        end

        context 'for an another error' do
          let(:socker_error_message) { 'whatever' }

          it 'raises this error' do
            expect do
              subject
            end.to raise_error(SocketError)
          end
        end
      end

      context 'for a Errno::EHOSTUNREACH no route to host' do
        before do
          stub_request(:get, valid_uri.to_s).to_raise(
            Errno::EHOSTUNREACH
          )
        end

        it 'logs as error this host down' do
          expect_any_instance_of(MonitoringService).to receive(:track_provider_error_from_response).with(
            an_instance_of(SIADE::V2::Responses::ServiceUnavailable),
            anything
          )

          subject
        end

        its(:http_code) { is_expected.to eq 502 }
        its(:response) { is_expected.to be_a SIADE::V2::Responses::ServiceUnavailable }
      end

      context 'for a Errno::ENETUNREACH network is unreachable' do
        before do
          stub_request(:get, valid_uri.to_s).to_raise(
            Errno::ENETUNREACH
          )
        end

        it 'logs as error' do
          expect_any_instance_of(MonitoringService).to receive(:track_provider_error_from_response).with(
            an_instance_of(SIADE::V2::Responses::NetworkError),
            anything
          )

          subject
        end

        its(:http_code) { is_expected.to eq 502 }
        its(:response) { is_expected.to be_a SIADE::V2::Responses::NetworkError }
      end

      context 'for an EOFError, which is generaly a timeout' do
        before do
          stub_request(:get, valid_uri.to_s).to_raise(
            EOFError
          )
        end

        it 'logs as error' do
          expect_any_instance_of(MonitoringService).to receive(:track_provider_error_from_response).with(
            instance_of(SIADE::V2::Responses::TimeoutError),
            anything
          )

          subject
        end

        its(:http_code) { is_expected.to eq 504 }
        its(:response) { is_expected.to be_a SIADE::V2::Responses::TimeoutError }
      end
    end
  end

  describe 'default HTTP options' do
    context 'with RestClient' do
      let(:random_request_class) do
        Class.new(described_class) do
          def rest_client_options
            { very_option: 'wow' }
          end
        end
      end

      it 'inherits default options' do
        req = random_request_class.new
        opt = req.send(:all_rest_client_options)

        expect(opt).to eq({
          very_option: 'wow',
          open_timeout: 10,
          read_timeout: 10
        })
      end
    end
  end
end
