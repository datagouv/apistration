RSpec.describe ValidateResponse do
  subject { DummyValidateResponse.call(params:, response:, operation_id:) }

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

  let(:operation_id) { 'test' }

  context 'with a OK response' do
    let(:response) { instance_double(Net::HTTPOK, code: '200') }

    it { is_expected.to be_a_success }
  end

  context 'with an unknown provider response' do
    let(:response) { instance_double(Net::HTTPInternalServerError, code: '500', body: error_body, to_hash: { 'header' => 'value' }) }
    let(:error_body) { 'FATAL ERROR' }

    it { is_expected.to be_a_failure }

    context 'when it is not an API Particulier operation_id' do
      let(:operation_id) { 'whatever' }

      it 'does not adds encrypted params to monitoring private context' do
        subject

        error = subject.errors.first

        expect(error.monitoring_private_context).to eq(
          {
            http_response_code: '500',
            http_response_body: error_body,
            http_response_headers: { 'header' => 'value' }
          }
        )
      end

      it 'does not call encrypt data service with params as json' do
        expect(DataEncryptor).not_to receive(:new).with(params.to_json)

        subject
      end
    end

    context 'when it is an API Particulier operation_id' do
      let(:operation_id) { 'api_particulier_whatever' }

      let(:encrypt_data) { instance_double(DataEncryptor, encrypt: 'encrypted_data') }

      before do
        allow(DataEncryptor).to receive(:new).and_return(encrypt_data)
      end

      context 'when data encryptor works' do
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
          expect(DataEncryptor).to receive(:new).with(params.to_json)

          subject
        end
      end

      describe 'when data encryptor fails' do
        before do
          allow(encrypt_data).to receive(:encrypt).and_raise(GPGME::Error::InvalidValue.new('whatever'))
        end

        it 'tracks error' do
          expect(MonitoringService.instance).to receive(:track).with(:error, 'GPGME::Error::InvalidValue').and_call_original

          subject
        end

        it 'does not raises error' do
          expect { subject }.not_to raise_error
        end
      end
    end
  end
end
