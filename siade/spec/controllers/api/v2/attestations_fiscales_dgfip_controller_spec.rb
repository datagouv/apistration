RSpec.describe API::V2::AttestationsFiscalesDGFIPController, type: :controller do
  before do
    allow_any_instance_of(MaintenanceService).to receive(:on?).and_return(maintenance)
  end

  let(:maintenance) { false }

  describe 'when DGFiP authentication fails' do
    subject { response }

    let(:siren) { invalid_siren }
    let(:token) { yes_jwt }
    let(:user_id) { valid_dgfip_user_id }

    before do
      allow_any_instance_of(AuthenticateDGFIPService).to receive(:authenticate!)
      allow_any_instance_of(AuthenticateDGFIPService).to receive(:success?).and_return(false)
      get :show, params: { token: token, siren: siren }.merge(mandatory_params)
    end

    its(:status) { is_expected.to eq(502) }

    it 'returns 502 with error message' do
      json = JSON.parse(response.body)

      expect(json).to have_json_error(detail: "L'authentification auprès du fournisseur de données 'DGFIP' a échoué")
    end
  end

  describe 'non-regression test: authentication returns a service unavailable' do
    subject { response }

    let(:siren) { invalid_siren }
    let(:token) { yes_jwt }
    let(:user_id) { valid_dgfip_user_id }

    before do
      stub_request(:post, /#{Siade.credentials[:dgfip_authenticate_url]}.*/).to_raise(Errno::ECONNREFUSED)

      get :show, params: { token: token, siren: siren }.merge(mandatory_params)
    end

    its(:status) { is_expected.to eq(502) }

    it 'returns 502 with error message' do
      json = JSON.parse(response.body)

      expect(json).to have_json_error(detail: "L'authentification auprès du fournisseur de données 'DGFIP' a échoué")
    end
  end

  describe 'with valid DGFIP Authentication' do
    before do
      allow_any_instance_of(AuthenticateDGFIPService).to receive(:authenticate!)
      allow_any_instance_of(AuthenticateDGFIPService).to receive(:success?).and_return(true)
      allow_any_instance_of(AuthenticateDGFIPService).to receive(:cookie).and_return('valid_cookie')
      # Imperative to have a persistant user_id in VCR cassettes
      allow(UserIdDGFIPService).to receive(:call).and_return(valid_dgfip_user_id)
    end

    it_behaves_like 'unauthorized'
    it_behaves_like 'forbidden'
    it_behaves_like 'ask_for_mandatory_parameters'

    describe 'unprocessable entity siren' do
      subject { response }

      let(:siren) { invalid_siren }
      let(:token) { yes_jwt }

      before do
        get :show, params: { token: token, siren: siren }.merge(mandatory_params)
      end

      its(:status) { is_expected.to eq(422).or eq(502) } # 502 because no informations are sent here

      it 'returns 422 with error message' do
        json = JSON.parse(response.body)

        expect(json).to have_json_error(detail: invalid_siren_error_message)
      end
    end

    describe 'with invalid params', vcr: { cassette_name: 'attestations_fiscales_dgfip_controller_invalid' } do
      subject { response }

      before do
        get :show, params: { token: token, siren: siren, siren_is: siren_is, siren_tva: siren_tva }.merge(mandatory_params)
      end

      let(:siren) { valid_siren }
      let(:token) { yes_jwt }

      context 'siren IS is invalid' do
        let(:siren_is)  { invalid_siren }
        let(:siren_tva) { valid_siren }

        its(:status) { is_expected.to eq(422) }

        it 'returns 422 with error message' do
          json = JSON.parse(response.body)
          expect(json).to have_json_error(detail: invalid_siren_error_message)
        end
      end

      context 'siren TVA is invalid' do
        let(:siren_tva) { invalid_siren }
        let(:siren_is)  { valid_siren }

        its(:status) { is_expected.to eq(422) }

        it 'returns 422 with error message' do
          json = JSON.parse(response.body)
          expect(json).to have_json_error(detail: invalid_siren_error_message)
        end
      end
    end
  end

  describe 'not found siren', vcr: { cassette_name: 'attestations_fiscales_dgfip_controller_with_ceased_siren' } do
    subject { response }

    before do
      # Imperative to have a persistant user_id in VCR cassettes
      allow(UserIdDGFIPService).to receive(:call).and_return(valid_dgfip_user_id)
      get :show, params: { token: token, siren: siren }.merge(mandatory_params)
    end

    let(:siren) { ceased_siren }
    let(:token) { yes_jwt }

    its(:status) { is_expected.to eq(404) }

    it 'returns 404 with error message' do
      json = JSON.parse(response.body)

      expect(json).to have_json_error(detail: 'Le siret ou siren indiqué n\'existe pas, n\'est pas connu, n\'est pas en règle de ses obligations fiscales ou ne comporte aucune information pour cet appel.')
    end
  end

  describe 'happy path' do
    shared_examples 'all_params_are_valid' do
      its(:status) { is_expected.to eq(200) }
      its(:body) { is_expected.to match(/attestation_fiscale_dgfip.pdf/) }
    end

    before do
      # Imperative to have a persistant user_id in VCR cassettes
      allow(UserIdDGFIPService).to receive(:call).and_return(valid_dgfip_user_id)
    end

    let(:siren) { valid_siren(:dgfip) }
    let(:token) { yes_jwt }

    context 'and no siren_is or siren_tva', vcr: { cassette_name: 'attestations_fiscales_dgfip_controller_with_valid_siren' } do
      subject { get :show, params: { token: token, siren: siren }.merge(mandatory_params) }

      it_behaves_like 'all_params_are_valid'
    end

    context 'and siren_is', vcr: { cassette_name: 'attestations_fiscales_dgfip_controller_with_valid_siren_is' } do
      subject { get :show, params: { token: token, siren: siren, siren_is: siren_is }.merge(mandatory_params) }

      let(:siren_is) { danone_siren }

      it_behaves_like 'all_params_are_valid'
    end

    context 'and siren_tva', vcr: { cassette_name: 'attestations_fiscales_dgfip_controller_with_valid_siren_tva' } do
      subject { get :show, params: { token: token, siren: siren, siren_tva: siren_tva }.merge(mandatory_params) }

      let(:siren_tva) { danone_siren }

      it_behaves_like 'all_params_are_valid'
    end

    context 'and siren_is and siren_tva', vcr: { cassette_name: 'attestations_fiscales_dgfip_controller_with_valid_params' } do
      subject { get :show, params: { token: token, siren: siren, siren_is: siren_is, siren_tva: siren_tva }.merge(mandatory_params) }

      let(:siren_is)  { danone_siren }
      let(:siren_tva) { danone_siren }

      it_behaves_like 'all_params_are_valid'
    end

    context 'and siren_is and siren_tva are a valid example', vcr: { cassette_name: 'attestations_fiscales_dgfip_controller_with_valid_params_is_tva' } do
      subject { get :show, params: { token: token, siren: siren, siren_is: siren_is, siren_tva: siren_tva }.merge(mandatory_params) }

      let(:siren) { '532010576' }
      let(:siren_is)  { '492041066' }
      let(:siren_tva) { '492041066' }

      it_behaves_like 'all_params_are_valid'
    end
  end

  describe 'when endpoint is in maintenance' do
    let(:maintenance) { true }

    let(:siren) { valid_siren(:dgfip) }
    let(:token) { yes_jwt }

    before do
      get :show, params: { siren: siren, token: token, error_format: 'json_api' }.merge(mandatory_params)
    end

    it 'returns 502 with maintenance message and retry_in in meta' do
      expect(response.code.to_i).to eq 502

      json_errors = JSON.parse(response.body)['errors']

      expect(json_errors[0]['title']).to eq('Maintenance du fournisseur de données')
      expect(json_errors[0]['meta']).to have_key('retry_in')
    end
  end
end
