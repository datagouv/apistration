RSpec.describe APIEntreprise::V2::EffectifsAnnuelsEntrepriseACOSSCovidController, type: :controller do
  let(:token) { yes_jwt }
  let(:siren) { valid_siren }

  it_behaves_like 'unauthorized', :show
  it_behaves_like 'ask_for_mandatory_parameters', :show

  describe 'show' do
    subject { get :show, params: { siren: siren, token: token }.merge(mandatory_params) }

    describe 'happy path' do
      let(:valid_response) do
        {
          siren: valid_siren,
          annee: '2019',
          effectifs_mensuels: '1.00'
        }
      end

      before do
        stub_request(:get, "http://127.0.0.1/effectifs_annuels_entreprise/#{siren}").and_return(
          status: 200,
          body: valid_response.to_json
        )
      end

      it 'returns 200' do
        expect(subject.status).to eq(200)
      end

      it 'has a valid body' do
        expect(subject.body).to eq(valid_response.to_json)
      end
    end

    describe 'when there is a timeout' do
      let(:timeout_error) do
        [
          Net::OpenTimeout,
          Net::ReadTimeout
        ].sample
      end

      before do
        stub_request(:get, "http://127.0.0.1/effectifs_annuels_entreprise/#{siren}").to_raise(timeout_error)
      end

      it 'returns 502' do
        expect(subject.status).to eq(502)
      end

      it 'has an error body' do
        expect(JSON.parse(subject.body)).to have_json_error(
          detail: 'Le service intermédiaire n\'a pas répondu'
        )
      end
    end
  end
end
