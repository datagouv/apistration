RSpec.describe SIADE::V2::Responses::Exercices, type: :provider_response do
  let(:options) do
    {
      cookie:  cookie,
      user_id: valid_dgfip_user_id
    }
  end
  subject { SIADE::V2::Requests::Exercices.new(siret, options).perform.response }

  context 'when siret is not found', vcr: { cassette_name: 'exercice_with_not_found_siret' } do
    let(:siret) { non_existent_siret }
    let(:cookie) { 'lemondgfip=bf91ce99ea967a4e24fffc2ad76d9145_519c42a2f4f4d80a5a5ff060246caf12; domain=.dgfip.finances.gouv.fr; path=/' }

    its(:http_code) { is_expected.to eq 404 }
  end

  context 'when siret is found', vcr: { cassette_name: 'exercice_with_valid_siret' } do
    let(:siret) { valid_siret(:exercice) }
    let(:cookie) { 'lemondgfip=337804d37291c5ab43a5419f67a542af_047e83a53cca805e6a773d6be8ae4dbb; domain=.dgfip.finances.gouv.fr; path=/' }

    its(:http_code) { is_expected.to eq 200 }
  end
end
