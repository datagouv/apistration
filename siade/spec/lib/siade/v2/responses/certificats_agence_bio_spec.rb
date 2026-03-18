RSpec.describe SIADE::V2::Responses::CertificatsAgenceBIO, type: :provider_response do
  subject { SIADE::V2::Requests::CertificatsAgenceBIO.new(siret).perform.response }

  context 'when active certifications exist for the given siret', vcr: { cassette_name: 'agence_bio/with_valid_siret' } do
    let(:siret) { valid_siret(:agence_bio) }

    its(:errors)    { is_expected.to be_empty }
    its(:http_code) { is_expected.to eq(200) }
  end

  context 'when no active certifications exist for the given siret', vcr: { cassette_name: 'agence_bio/with_not_found_siret' } do
    let(:siret) { not_found_siret(:agence_bio) }

    its(:errors)    { is_expected.to have_error('Le siret ou siren indiqué n\'existe pas, n\'est pas connu ou ne comporte aucune information pour cet appel') }
    its(:http_code) { is_expected.to eq(404) }
  end
end
