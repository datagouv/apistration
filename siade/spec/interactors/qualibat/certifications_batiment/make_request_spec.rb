RSpec.describe QUALIBAT::CertificationsBatiment::MakeRequest, type: :make_request do
  subject { described_class.call(params:, token:) }

  let(:params) do
    {
      siret:
    }
  end

  let(:token) { QUALIBAT::CertificationsBatiment::Authenticate.call.token }

  context 'when siret is valid' do
    let(:siret) { valid_siret(:qualibat) }

    before do
      stub_qualibat_authenticate
      stub_qualibat_valid_siret
    end

    it { is_expected.to be_success }

    its(:response) { is_expected.to be_a(Net::HTTPOK) }
  end

  context 'when siret is not found' do
    let(:siret) { not_found_siret(:qualibat) }

    before do
      stub_qualibat_authenticate
      stub_qualibat_not_found_siret
    end

    it { is_expected.to be_success }

    its(:response) { is_expected.to be_a(Net::HTTPOK) }
  end
end
