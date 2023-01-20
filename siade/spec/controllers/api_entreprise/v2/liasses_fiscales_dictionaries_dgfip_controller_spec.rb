RSpec.describe APIEntreprise::V2::LiassesFiscalesDictionariesDGFIPController, type: :controller do
  subject { response }

  let(:token) { yes_jwt }
  let(:annee) { 2017 }

  describe 'happy path', vcr: { cassette_name: 'dgfip/liasses_fiscales/valid' } do
    before do
      allow(UserIdDGFIPService).to receive(:call).and_return(valid_dgfip_user_id)
    end

    before { get :show, params: { token:, annee: 2017 }.merge(mandatory_params) }

    its(:status) { is_expected.to eq(200) }

    it 'response matches' do
      json = JSON.parse(response.body)
      expect(json).to match_json_schema('liasse_fiscale_dictionary')
    end
  end

  describe 'with a valid DGFIP authentication', vcr: { cassette_name: 'dgfip/liasses_fiscales/with_non_existent_siren' } do
    before do
      allow(UserIdDGFIPService).to receive(:call).and_return(valid_dgfip_user_id)
    end

    it_behaves_like 'unauthorized', :show, annee: 2017
    it_behaves_like 'forbidden', :show, annee: 2017

    describe 'wrong year format' do
      before do
        get :show, params: { token:, annee: 'not a year' }.merge(mandatory_params)
      end

      its(:status) { is_expected.to eq(422) }
      it { expect(JSON.parse(subject.body)).to have_json_error(detail: 'L\'année n\'est pas correctement formatée') }
    end
  end

  describe 'without a valid DGFIP authentication' do
    before do
      allow_any_instance_of(AuthenticateDGFIPService).to receive(:authenticate!)
      allow_any_instance_of(AuthenticateDGFIPService).to receive(:success?).and_return(false)
    end

    before { get :show, params: { token:, annee: }.merge(mandatory_params) }

    its(:status) { is_expected.to eq(502) }

    it 'returns 502 with error message' do
      json = JSON.parse(response.body)

      expect(json).to have_json_error(detail: "L'authentification auprès du fournisseur de données 'DGFIP - Adélie' a échoué")
    end
  end
end
