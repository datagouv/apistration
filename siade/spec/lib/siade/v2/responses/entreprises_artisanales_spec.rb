RSpec.describe SIADE::V2::Responses::EntreprisesArtisanales, type: :provider_response do
  subject { SIADE::V2::Requests::EntreprisesArtisanales.new(siren).perform.response }

  context 'when siren is not found', vcr: { cassette_name: 'rnm_cma/not_found_siren' } do
    let(:siren) { not_found_siren(:rnm_cma) }

    its(:class) { is_expected.to eq(SIADE::V2::Responses::ResourceNotFound) }
  end
end
