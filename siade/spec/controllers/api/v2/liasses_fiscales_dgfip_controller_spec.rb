RSpec.describe API::V2::LiassesFiscalesDGFIPController, type: :controller do
  let(:token) { yes_jwt }

  describe 'happy path', vcr: { cassette_name: 'dgfip/liasses_fiscales/valid' } do
    before do
      allow(UserIdDGFIPService).to receive(:call).and_return(valid_dgfip_user_id)
    end

    describe 'happy path: liasse complete' do
      subject { response }

      before { get :show, params: { token: token, siren: valid_siren(:liasse_fiscale), annee: 2017 }.merge(mandatory_params) }

      its(:status) { is_expected.to eq(200) }

      it 'response matches' do
        json = JSON.parse(response.body)
        expect(json).to match_json_schema('liasse_fiscale_complete')
      end
    end

    describe 'happy path: liasse dictionnaire' do
      subject { response }

      let(:siren) { valid_siren(:liasse_fiscale) }

      before { get :dictionnaire, params: { token: token, siren: siren, annee: 2017 }.merge(mandatory_params) }

      its(:status) { is_expected.to eq(200) }

      it 'response matches' do
        json = JSON.parse(response.body)
        expect(json).to match_json_schema('liasse_fiscale_dictionary')
      end
    end

    describe 'happy path: liasse dictionnaire without siren' do
      subject { response }

      before { get :dictionnaire, params: { token: token, annee: 2017 }.merge(mandatory_params) }

      its(:status) { is_expected.to eq(200) }

      it 'response matches' do
        json = JSON.parse(response.body)
        expect(json).to match_json_schema('liasse_fiscale_dictionary')
      end
    end

    describe 'happy path: liasse declaration' do
      subject { response }

      before { get :declaration, params: { token: token, siren: valid_siren(:liasse_fiscale), annee: 2017 }.merge(mandatory_params) }

      its(:status) { is_expected.to eq(200) }

      it 'response matches' do
        json = JSON.parse(response.body)
        expect(json).to match_json_schema('liasse_fiscale_declaration')
      end
    end
  end

  describe 'with a valid DGFiP authentication', vcr: { cassette_name: 'dgfip/liasses_fiscales/with_non_existent_siren' } do
    before do
      allow(UserIdDGFIPService).to receive(:call).and_return(valid_dgfip_user_id)
    end

    it_behaves_like 'unauthorized', :show, annee: 2017
    it_behaves_like 'unauthorized', :dictionnaire, annee: 2017
    it_behaves_like 'unauthorized', :declaration, annee: 2017

    it_behaves_like 'forbidden', :show, annee: 2017
    it_behaves_like 'forbidden', :dictionnaire, annee: 2017
    it_behaves_like 'forbidden', :declaration, annee: 2017

    # No 'not_found' for dictionary because we don't need siren for this request
    it_behaves_like 'not_found', action: :show, annee: 2017
    it_behaves_like 'not_found', action: :declaration, annee: 2017

    # No 'unprocessable_entity' for dictionary because we don't need siren for this request
    it_behaves_like 'unprocessable_entity', :show, :siren, annee: 2017
    it_behaves_like 'unprocessable_entity', :declaration, :siren, annee: 2017

    describe 'wrong year format' do
      subject { response }

      before do
        get :show, params: { token: yes_jwt, siren: valid_siren(:liasse_fiscale), annee: 'not a year' }.merge(mandatory_params)
      end

      its(:status) { is_expected.to eq(422) }
      it { expect(JSON.parse(subject.body)).to have_json_error(detail: 'L\'année n\'est pas correctement formatée') }
    end
  end

  describe 'when DGFiP authentication fails' do
    subject { response }

    let(:siren) { invalid_siren }
    let(:token) { yes_jwt }

    before do
      allow_any_instance_of(AuthenticateDGFIPService).to receive(:authenticate!)
      allow_any_instance_of(AuthenticateDGFIPService).to receive(:success?).and_return(false)
    end

    shared_examples 'DGFiP authentication failed' do
      its(:status) { is_expected.to eq(502) }

      it 'returns 502 with error message' do
        json = JSON.parse(response.body)

        expect(json).to have_json_error(detail: "L'authentification auprès du fournisseur de données 'DGFIP' a échoué")
      end
    end

    describe 'liasse complete' do
      before { get :show, params: { token: token, siren: siren, annee: 2017 }.merge(mandatory_params) }

      it_behaves_like 'DGFiP authentication failed'
    end

    describe 'liasse declaration' do
      before { get :declaration, params: { token: token, siren: siren, annee: 2017 }.merge(mandatory_params) }

      it_behaves_like 'DGFiP authentication failed'
    end

    describe 'liasse dictionnaire' do
      before { get :dictionnaire, params: { token: token, siren: siren, annee: 2017 }.merge(mandatory_params) }

      it_behaves_like 'DGFiP authentication failed'
    end
  end
end
