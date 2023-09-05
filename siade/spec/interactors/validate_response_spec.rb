RSpec.describe ValidateResponse do
  subject { DummyValidateResponse.call(params:, response:) }

  before(:all) do
    class DummyValidateResponse < ValidateResponse
      protected

      def call
        case response.code
        when '500'
          unknown_provider_response!
        end
      end

      def provider_name
        'INSEE'
      end
    end
  end

  let(:params) do
    {
      key: 'value'
    }
  end

  context 'with a OK response' do
    let(:response) { instance_double(Net::HTTPOK, code: '200') }

    it { is_expected.to be_a_success }
  end

  context 'with an unknown provider response' do
    let(:response) { instance_double(Net::HTTPInternalServerError, code: '500', body: error_body, to_hash: { 'header' => 'value' }) }
    let(:error_body) { 'FATAL ERROR' }
    let(:encrypt_data) { instance_double(EncryptData, perform: 'encrypted_data') }

    before do
      allow(EncryptData).to receive(:new).and_return(encrypt_data)
    end

    it { is_expected.to be_a_failure }

    it 'adds context to monitoring, with encrypted params' do
      subject

      error = subject.errors.first

      expect(error.monitoring_private_context).to eq(
        {
          http_response_code: '500',
          http_response_body: error_body,
          http_response_headers: { 'header' => 'value' },
          encrypted_params: 'encrypted_data'
        }
      )
    end

    it 'calls encrypt data service with params as json' do
      expect(EncryptData).to receive(:new).with(params.to_json)

      subject
    end
  end
end
