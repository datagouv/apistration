RSpec.describe API::V2::CertificatsAgenceBIOController, type: :controller do
  it_behaves_like 'unauthorized'
  it_behaves_like 'unprocessable_entity', :show, :siret
  it_behaves_like 'forbidden'
  it_behaves_like 'ask_for_mandatory_parameters'

  describe 'happy path' do
    context 'when siret is not found', vcr: { cassette_name: 'agence_bio/with_not_found_siret' } do
      it_behaves_like 'not_found', siret: not_found_siret(:agence_bio)
    end

    context 'when siret is valid', vcr: { cassette_name: 'agence_bio/with_valid_siret' } do
      it 'returns HTTP code 200' do
        expect(response).to have_http_status(:ok)
      end

      pending 'test body here'
    end
  end
end

