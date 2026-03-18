RSpec.describe SIADE::V2::Responses::CertificatsRGEAdeme, type: :provider_response do
  subject { SIADE::V2::Requests::CertificatsRGEAdeme.new(siret).perform.response }

  context 'when data exists for the given siret', vcr: { cassette_name: 'ademe/rge/with_valid_siret' } do
    let(:siret) { valid_siret(:rge_ademe) }

    its(:errors)    { is_expected.to be_empty }
    its(:http_code) { is_expected.to eq(200) }
  end

  context 'when no data exists for the given siret', vcr: { cassette_name: 'ademe/rge/with_not_found_siret' } do
    let(:siret) { not_found_siret(:rge_ademe) }

    its(:errors)    { is_expected.to have_error('Le siret ou siren indiqué n\'existe pas, n\'est pas connu ou ne comporte aucune information pour cet appel') }
    its(:http_code) { is_expected.to eq(404) }
  end
end
