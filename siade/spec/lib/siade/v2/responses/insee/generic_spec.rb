RSpec.describe SIADE::V2::Responses::INSEE::Generic, type: :provider_response do
  subject { SIADE::V2::Requests::INSEE::Etablissement.new(siret).tap(&:perform).response }

  before { allow_any_instance_of(RenewINSEETokenService).to receive(:current_token_expired?).and_return(false) }

  context 'when siret is not found', vcr: { cassette_name: 'api_insee_fr/siret/non_existent' } do
    let(:siret) { non_existent_siret }

    its(:http_code) { is_expected.to eq 404 }
  end

  context 'when siret is found', vcr: { cassette_name: 'api_insee_fr/siret/active_AE' } do
    let(:siret) { sirets_insee_v3[:active_AE] }

    its(:http_code) { is_expected.to eq 200 }
  end
end
