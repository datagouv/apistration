RSpec.describe QUALIBAT::CertificationsBatiment::MakeRequest, type: :make_request do
  subject { described_class.call(params:, token:) }

  let(:params) do
    {
      siret:
    }
  end

  let(:token) { QUALIBAT::CertificationsBatiment::Authenticate.call.token }

  context 'when siret is valid', vcr: { cassette_name: 'qualibat/certifications_batiment/valid_siret_2' } do
    let(:siret) { valid_siret(:qualibat) }

    it { is_expected.to be_success }

    its(:response) { is_expected.to be_a(Net::HTTPOK) }
  end

  context 'when siret is not found', vcr: { cassette_name: 'qualibat/certifications_batiment/not_found_siret_2' } do
    let(:siret) { not_found_siret(:qualibat) }

    it { is_expected.to be_success }

    its(:response) { is_expected.to be_a(Net::HTTPOK) }
  end
end
