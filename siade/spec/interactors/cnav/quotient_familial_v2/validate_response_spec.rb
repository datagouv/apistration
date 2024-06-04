RSpec.describe CNAV::QuotientFamilialV2::ValidateResponse, type: :validate_response do
  subject { described_class.call(response:, provider_name: 'CNAV', operation_id: 'api_particulier_whatever') }

  context 'with 200 response' do
    let(:response) do
      instance_double(Net::HTTPOK, code: 200, body:)
    end

    context 'with valid body' do
      let(:body) { read_payload_file('cnav/quotient_familial_v2/make_request_valid.json') }

      it { is_expected.to be_a_success }

      its(:errors) { is_expected.to be_empty }
    end

    context 'with invalid body' do
      let(:body) { 'lol' }

      it { is_expected.to be_a_failure }

      its(:errors) { is_expected.to include(instance_of(ProviderUnknownError)) }
    end
  end

  context 'with not found response' do
    before do
      allow(EncryptData).to receive(:new).and_return(encrypt_data)
    end

    let(:response) do
      instance_double(Net::HTTPNotFound, code: 404, body:, header: { 'X-APISECU-FD' => '00810011' })
    end

    let(:body) { read_payload_file('cnav/quotient_familial_v2/404.json') }
    let(:error_body) { 'FATAL ERROR' }
    let(:encrypt_data) { instance_double(EncryptData, perform: 'encrypted_data') }

    it { is_expected.to be_a_failure }
    its(:errors) { is_expected.to include(instance_of(NotFoundError)) }
  end

  context 'with 500 response' do
    let(:response) do
      instance_double(Net::HTTPInternalServerError, code: 500)
    end

    it { is_expected.to be_a_failure }

    its(:errors) { is_expected.to include(instance_of(ProviderInternalServerError)) }
  end

  context 'with random http code response' do
    let(:response) do
      instance_double(Net::HTTPOK, code: 401)
    end

    it { is_expected.to be_a_failure }

    its(:errors) { is_expected.to include(instance_of(ProviderUnknownError)) }
  end
end
