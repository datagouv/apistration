require 'rails_helper'

RSpec.describe MakeRequest, type: :interactor do
  before(:all) do
    class DummyMakeRequest < MakeRequest
      protected

      def api_call
        context.response = http_wrapper do
          Net::HTTP::Get.new(request_uri)
        end
      end

      def request_uri
        URI('https://entreprise.api.gouv.fr')
      end
    end
  end

  subject { DummyMakeRequest.call(provider_name: provider_name) }

  let(:uri) { DummyMakeRequest.new.send(:request_uri) }
  let(:provider_name) { 'INSEE' }

  describe 'response presence in context' do
    context 'when response is not present on context' do
      before do
        allow_any_instance_of(DummyMakeRequest).to receive(:api_call)
      end

      it 'raises a ResponseNotDefined error' do
        expect {
          subject
        }.to raise_error(MakeRequest::ResponseNotDefined)
      end
    end
  end

  describe 'when request succeed' do
    before do
      stub_request(:get, uri.to_s).to_return(
        status: 200,
        body: {
          success: true,
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

    context 'for a connection refused error' do
      before do
        stub_request(:get, uri.to_s).to_raise(
          [
            Errno::ECONNREFUSED,
            Errno::ECONNRESET,
            Errno::EHOSTUNREACH,
          ].sample
        )
      end

      it { is_expected.to be_a_failure }

      it 'adds ProviderUnavailable to errors' do
        expect(subject.errors).to include(instance_of(ProviderUnavailable))
      end
    end

    context 'for a socket error' do
      let(:socket_error) { SocketError.new(socket_error_message) }

      before do
        stub_request(:get, uri.to_s).to_raise(socket_error)
      end

      context 'for a DNS resolution fail (no address associated)' do
        let(:socket_error_message) { 'Failed to open TCP connection to api.entreprise.gouv.fr:443 getaddrinfo: No address associated with hostname)' }

        it { is_expected.to be_a_failure }

        it 'adds DnsResolutionError to errors' do
          expect(subject.errors).to include(instance_of(DnsResolutionError))
        end
      end

      context 'for a DNS resolution fail (nodename nor servname associated)' do
        let(:socket_error_message) { 'Failed to open TCP connection to api.entreprise.gouv.fr:443 (getaddrinfo: nodename nor servname provided, or not known)' }


        it { is_expected.to be_a_failure }

        it 'adds DnsResolutionError to errors' do
          expect(subject.errors).to include(instance_of(DnsResolutionError))
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
  end
end
