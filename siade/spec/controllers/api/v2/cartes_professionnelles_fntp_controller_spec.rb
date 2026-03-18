RSpec.describe API::V2::CartesProfessionnellesFNTPController, type: :controller do
  it_behaves_like 'unauthorized'
  it_behaves_like 'unprocessable_entity'
  it_behaves_like 'forbidden'
  it_behaves_like 'ask_for_mandatory_parameters'

  context 'when siren is unknown from FNTP', vcr: { cassette_name: 'fntp_with_not_found_siren' } do
    it_behaves_like 'not_found'
  end

  context 'when request returns status 200', vcr: { cassette_name: 'fntp_controller_siren_valid' } do
    it_behaves_like 'happy_pdf_endpoint_siren', valid_siren(:fntp), 'carte_professionnelle_fntp'
  end
end
