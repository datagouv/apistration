RSpec.describe QUALIBAT::CertificationsBatiment::MakeRequest, type: :make_request do
  subject { described_class.call(params:) }

  let(:params) do
    {
      siret:
    }
  end

  context 'when siret is valid', vcr: { cassette_name: 'qualibat/certifications_batiment/valid_siret' } do
    let(:siret) { valid_siret(:qualibat) }

    it { is_expected.to be_success }

    its(:response) { is_expected.to be_a(Net::HTTPOK) }
  end

  context 'when siret is not found', vcr: { cassette_name: 'qualibat/certifications_batiment/not_found_siret' } do
    let(:siret) { not_found_siret(:qualibat) }

    it { is_expected.to be_success }

    its(:response) { is_expected.to be_a(Net::HTTPNotFound) }
  end
end
