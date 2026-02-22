RSpec.describe MakeRequest, type: :interactor do
  subject { DummyMakeRequest.call(provider_name:, params:, operation_id:) }

  before(:all) do
    class DummyMakeRequest < MakeRequest
      protected

      def api_call
        context.response = http_wrapper do
          Net::HTTP::Get.new(request_uri)
        end
      end

      def mocking_params
        context.params.merge(what: 'not_v2')
      end

      def mocking_params_v2
        context.params.merge(what: 'v2')
      end

      def request_uri
        URI('https://entreprise.api.gouv.fr')
      end
    end
  end

  let(:uri) { DummyMakeRequest.new.send(:request_uri) }
  let(:provider_name) { 'INSEE' }
  let(:operation_id) { 'operation_id' }
  let(:params) { { 'arg1' => 'value1' } }

  it_behaves_like 'a make request with working mocking_params'

  describe 'when request succeed' do
    before do
      stub_request(:get, uri.to_s).to_return(
        status: 200,
        body: {
          success: true
        }.to_json
      )
    end

    it { is_expected.to be_a_success }

    its(:response) { is_expected.to be_present }
    its(:errors) { is_expected.to be_empty }
  end

  context 'when request failed' do
    context 'when it is a timeout' do
      before do
        stub_request(:get, uri.to_s).to_timeout
      end

      it { is_expected.to be_a_failure }

      it 'adds ProviderTimeoutError to errors' do
        expect(subject.errors).to include(instance_of(ProviderTimeoutError))
      end
    end

    context 'when it is a gateway error (504)' do
      before do
        stub_request(:get, uri.to_s).to_return(
          status: 504
        )
      end

      it { is_expected.to be_a_failure }

      it 'adds ProviderTimeoutError to errors' do
        expect(subject.errors).to include(instance_of(ProviderTimeoutError))
      end
    end

    context 'for a bad gateway error (502)' do
      before do
        stub_request(:get, uri.to_s).to_return(
          status: 502
        )
      end

      it { is_expected.to be_a_failure }

      it 'adds ProviderUnavailable to errors' do
        expect(subject.errors).to include(instance_of(ProviderUnavailable))
      end
    end

    context 'for a connection refused error' do
      before do
        stub_request(:get, uri.to_s).to_raise(
          [
            Errno::ECONNREFUSED,
            Errno::ECONNRESET,
            Errno::EHOSTUNREACH
          ].sample
        )
      end

      it { is_expected.to be_a_failure }

      it 'adds ProviderUnavailable to errors' do
        expect(subject.errors).to include(instance_of(ProviderUnavailable))
      end
    end

    context 'for a network unreachable error' do
      before do
        stub_request(:get, uri.to_s).to_raise(
          Errno::ENETUNREACH
        )
      end

      it { is_expected.to be_a_failure }

      it 'adds NetworkError to errors' do
        expect(subject.errors).to include(instance_of(NetworkError))
      end
    end

    context 'when it is an OpenSSL error' do
      let(:openssl_error) { OpenSSL::SSL::SSLError.new(ssl_error_message) }

      let!(:stubbed_request) do
        stub_request(:get, uri.to_s).to_raise(
          openssl_error
        )
      end

      context 'when it is a "SSLv3/TLS write client hello" error' do
        let(:ssl_error_message) { 'SSL_connect SYSCALL returned=5 errno=0 SSLv3/TLS write client hello' }

        it { is_expected.to be_a_failure }

        it 'adds NetworkError to errors' do
          expect(subject.errors).to include(instance_of(NetworkError))
        end
      end

      context 'when it is a "certificate verify failed" error' do
        let(:ssl_error_message) { 'SSL_connect returned=1 errno=0 peeraddr=1.2.3.4:443 state=error: certificate verify failed (certificate has expired)' }

        it { is_expected.to be_a_failure }

        it 'adds SSLCertificateError to errors' do
          expect(subject.errors).to include(instance_of(SSLCertificateError))
        end
      end

      context 'when it is a "unexpected eof while reading" error' do
        let(:ssl_error_message) { 'unexpected eof while reading' }

        it { is_expected.to be_a_failure }

        it 'retries 3 times then adds ProviderUnavailable to errors' do
          subject

          expect(stubbed_request).to have_been_requested.times(3)
          expect(subject.errors).to include(instance_of(ProviderUnavailable))
        end
      end

      context 'when it is an another error' do
        let(:ssl_error_message) { 'whatever' }

        it 'raises this error' do
          expect {
            subject
          }.to raise_error(OpenSSL::SSL::SSLError)
        end
      end
    end

    context 'for a socket error' do
      let(:socket_error) { SocketError.new(socket_error_message) }

      before do
        stub_request(:get, uri.to_s).to_raise(socket_error)
      end

      [
        'nodename nor servname provided, or not known',
        'No address associated with hostname',
        'Name or service not known',
        'Temporary failure in name resolution',
        'getaddrinfo(3): Temporary failure in name resolution'
      ].each do |dns_error_message|
        context 'for a DNS resolution fail (no address associated)' do
          let(:socket_error_message) { "Failed to open TCP connection to www.google.com:443 (#{dns_error_message})" }

          it { is_expected.to be_a_failure }

          it 'adds DnsResolutionError to errors' do
            expect(subject.errors).to include(instance_of(DnsResolutionError))
          end
        end
      end

      context 'for an another error' do
        let(:socket_error_message) { 'whatever' }

        it 'raises this error' do
          expect {
            subject
          }.to raise_error(SocketError)
        end
      end
    end

    context 'for a Socket::ResolutionError (Ruby 3.x)' do
      before do
        stub_request(:get, uri.to_s).to_raise(
          Socket::ResolutionError.new('Temporary failure in name resolution')
        )
      end

      it { is_expected.to be_a_failure }

      it 'adds DnsResolutionError to errors' do
        expect(subject.errors).to include(instance_of(DnsResolutionError))
      end
    end

    context 'for a service unavailable' do
      before do
        stub_request(:get, uri.to_s).to_return(
          status: 503
        )
      end

      it { is_expected.to be_a_failure }

      it 'adds ProviderUnavailable to errors' do
        expect(subject.errors).to include(instance_of(ProviderUnavailable))
      end
    end

    context 'when it is a redirection' do
      before do
        stub_request(:get, uri.to_s).to_return(
          status: 301,
          headers: {
            'Location' => "#{uri}/redirection"
          }
        )
      end

      it { is_expected.to be_a_failure }

      it 'adds DnsResolutionError to errors' do
        expect(subject.errors).to include(instance_of(UnexpectedRedirectionError))
      end
    end
  end

  describe 'mock behaviour' do
    let(:mock_service) { instance_double(MockService) }

    before do
      allow(MockService).to receive(:new).and_return(mock_service)
    end

    describe 'when it is a staging environment' do
      let!(:stubbed_request) { stub_request(:get, uri.to_s) }
      let(:mocked_data) do
        {
          status: 200,
          payload: {
            'status' => 'ok'
          }
        }
      end

      before do
        allow(Rails).to receive(:env).and_return('staging'.inquiry)
        allow(mock_service).to receive(:mock).and_return(mocked_data)
      end

      it 'does not make a request' do
        subject

        expect(stubbed_request).not_to have_been_requested
      end

      context 'when it is a v2 mocking' do
        let!(:operation_id) { 'api_particulier_v2_operation_id' }

        it 'calls MockService with v2 mocking_params' do
          subject

          expect(MockService).to have_received(:new).with(
            operation_id,
            params.merge(what: 'v2')
          )
          expect(mock_service).to have_received(:mock)
        end
      end

      context 'when it is not a v2 mocking' do
        it 'calls MockService with mocking_params' do
          subject

          expect(MockService).to have_received(:new).with(
            operation_id,
            params.merge(what: 'not_v2')
          )
          expect(mock_service).to have_received(:mock)
        end
      end

      it 'affects mocked data to context' do
        expect(subject.mocked_data).to eq(mocked_data)
      end
    end

    context 'when it is not a staging environment' do
      before do
        stub_request(:get, uri.to_s)
      end

      it 'does not call MockService' do
        subject

        expect(MockService).not_to have_received(:new)
      end

      it 'does not affect the mock status and payload to context' do
        expect(subject.mocked_data).to be_nil
      end
    end
  end
end
