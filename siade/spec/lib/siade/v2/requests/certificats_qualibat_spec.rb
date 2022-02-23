RSpec.describe SIADE::V2::Requests::CertificatsQUALIBAT, type: :provider_request do
  subject { described_class.new(siret).perform }

  context 'bad formated request' do
    let(:siret) { not_a_siret }

    its(:http_code) { is_expected.to eq(422) }
    its(:errors) { is_expected.to have_error(invalid_siret_error_message) }
  end

  context 'well formated request', vcr: { cassette_name: 'qualibat/certifications_batiment/valid_siret' } do
    let(:siret) { valid_siret(:qualibat) }

    its(:http_code) { is_expected.to eq(200) }
    its(:errors) { is_expected.to be_empty }
  end
end
