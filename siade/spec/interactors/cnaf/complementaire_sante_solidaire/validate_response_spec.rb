RSpec.describe CNAF::ComplementaireSanteSolidaire::ValidateResponse, type: :validate_response do
  subject { described_class.call(response:, provider_name: 'CNAF') }

  context 'with 200 response' do
    let(:response) do
      instance_double(Net::HTTPOK, code: 200, body:)
    end

    context 'with valid body' do
      let(:body) { Rails.root.join('spec/fixtures/payloads/cnaf/complementaire_sante_solidaire/make_request_valid.json').read }

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
    let(:response) do
      instance_double(Net::HTTPNotFound, code: 404, body:)
    end

    let(:body) { Rails.root.join('spec/fixtures/payloads/cnaf/complementaire_sante_solidaire/404.json').read }

    it { is_expected.to be_a_failure }

    its(:errors) { is_expected.to include(instance_of(NotFoundError)) }
  end

  context 'with random http code response' do
    let(:response) do
      instance_double(Net::HTTPOK, code: 401)
    end

    it { is_expected.to be_a_failure }

    its(:errors) { is_expected.to include(instance_of(ProviderUnknownError)) }
  end
end
