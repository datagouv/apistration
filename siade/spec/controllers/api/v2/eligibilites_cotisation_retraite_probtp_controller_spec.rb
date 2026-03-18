RSpec.describe API::V2::EligibilitesCotisationRetraitePROBTPController, type: :controller do

  it_behaves_like 'unauthorized'
  it_behaves_like 'unprocessable_entity', :show, :siret
  it_behaves_like 'forbidden'
  it_behaves_like 'ask_for_mandatory_parameters'

  describe '#show' do
    before do
      get :show, params: { siret: siret, token: yes_jwt }.merge(mandatory_params)
    end

    subject { JSON.parse(response.body) }

    context 'siret inconnu chez PROBTP', vcr: { cassette_name: 'probtp/eligibilite/with_not_found_siret' } do
      let(:siret) { not_found_siret(:probtp) }

      it_behaves_like 'not_found'
    end

    context 'siret non eligible PROBTP', vcr: { cassette_name: 'probtp/eligibilite/with_non_eligible_siret' } do
      let(:siret) { non_eligible_siret(:probtp) }

      it 'returns 200 and eligible is false' do
        expect(response).to have_http_status(200)
        expect(subject['eligible']).to be false
        expect(subject['message']).to eq('01 Compte non éligible pour attestation de cotisation')
      end
    end

    context 'siret eligible PROBTP',vcr: { cassette_name: 'probtp/eligibilite/with_eligible_siret' } do
      let(:siret) { eligible_siret(:probtp) }

      it 'returns 200 and eligible is true'  do
        expect(response).to have_http_status(200)
        expect(subject['eligible']).to be true
        expect(subject['message']).to eq('00 Compte éligible pour attestation de cotisation')
      end
    end
  end
end
