RSpec.describe API::V2::EntreprisesRestoredController, type: :controller do
  before { allow_any_instance_of(RenewINSEETokenService).to receive(:current_token_expired?).and_return(false) }

  let(:token) { yes_jwt }

  it_behaves_like 'unauthorized'
  it_behaves_like 'forbidden'
  it_behaves_like 'unprocessable_entity'
  it_behaves_like 'ask_for_mandatory_parameters'

  context 'when siren is not found', vcr: { cassette_name: 'api_insee_fr/siren/non_existent' } do
    it_behaves_like 'not_found'
  end

  context 'without param `with_non_diffusable` it returns 403', vcr: { cassette_name: 'api_insee_fr/siren/non_diffusable' } do
    subject { get :show, params: { siren: non_diffusable_siren, token: token }.merge(mandatory_params) }

    its(:status) { is_expected.to eq 451 }

    it 'returns 403 with error message' do
      expect(JSON.parse(subject.body)).to have_json_error(
        detail: 'Le SIREN est non diffusable, pour y accéder référez-vous à notre documentation.'
      )
    end
  end

  context 'with param `non_diffusables` it returns 200', vcr: { cassette_name: 'api_insee_fr/siren/non_diffusable' } do
    subject { get :show, params: { siren: non_diffusable_siren, token: token, non_diffusables: true }.merge(mandatory_params) }

    let(:json) { JSON.parse(subject.body).deep_symbolize_keys }

    its(:status) { is_expected.to eq 200 }

    it 'returns valid payload' do
      expect(json).to match_json_schema('insee/v2/entreprise')
    end

    it 'returns `diffusable` info' do
      expect(json.dig(:entreprise, :diffusable_commercialement)).to eq false
    end
  end

  describe 'retrievers failure', vcr: { cassette_name: 'api_insee_fr/siren/active_GE' } do
    subject { get :show, params: { siren: siren, token: token }.merge(mandatory_params) }

    let(:siren) { sirens_insee_v3[:active_GE] }

    context 'API entreprise fails' do
      before do
        allow_any_instance_of(SIADE::V2::Retrievers::EntreprisesRestored).to receive(:retrieve).and_return nil
        allow_any_instance_of(SIADE::V2::Retrievers::EntreprisesRestored).to receive(:success?).and_return false
        allow_any_instance_of(SIADE::V2::Retrievers::EntreprisesRestored).to receive(:http_code).and_return 503
        allow_any_instance_of(SIADE::V2::Retrievers::EntreprisesRestored).to receive(:errors).and_return [ProviderUnknownError.new('INSEE', 'artificial error')]
      end

      its(:status) { is_expected.to eq 503 }

      it 'has errors' do
        expect(JSON.parse(subject.body)).to have_json_error(detail: 'artificial error')
      end
    end

    context 'API etablissement fails' do
      before do
        allow_any_instance_of(SIADE::V2::Retrievers::EtablissementsRestored).to receive(:retrieve).and_return nil
        allow_any_instance_of(SIADE::V2::Retrievers::EtablissementsRestored).to receive(:success?).and_return false
        allow_any_instance_of(SIADE::V2::Retrievers::EtablissementsRestored).to receive(:http_code).and_return 503
        allow_any_instance_of(SIADE::V2::Retrievers::EtablissementsRestored).to receive(:errors).and_return [ProviderUnknownError.new('INSEE', 'artificial error')]
      end

      its(:status) { is_expected.to eq 206 }

      it 'has errors' do
        expect(JSON.parse(subject.body)).to have_json_error(detail: 'artificial error')
      end
    end
  end

  describe 'siren redirected to another siren', vcr: { cassette_name: 'api_insee_fr/siren/redirected' } do
    subject { get :show, params: { siren: siren, token: token }.merge(mandatory_params) }

    let(:siren) { redirected_siren }

    its(:status) { is_expected.to eq 301 }
    its(:location) { is_expected.to include "/v2/entreprises/778870675?#{mandatory_params.to_param}&token=#{token}" }
    its(:body) { is_expected.to match(%r{Vous êtes.+redirigé.+Le siren/siret demandé est un doublon et ne doit plus être utilisé.+Référez-vous à notre.+documentation.+pour plus de détails}m) }
  end

  shared_examples 'happy path' do |siren|
    subject(:json) do
      get :show, params: { siren: siren, token: token }.merge(mandatory_params)
      JSON.parse(response.body).deep_symbolize_keys
    end

    # Warning this test allow a LOT of nullable values (ie: ["null", "string"]) in json schema
    it { is_expected.to match_json_schema('insee/v2/entreprise') }

    it 'does not return `diffusable_commercialement`' do
      expect(subject[:entreprise]).not_to have_key(:diffusable_commercialement)
    end
  end

  sirens_insee_v3.each do |label, siren|
    context "well formated #{label}: #{siren}", vcr: { cassette_name: "api_insee_fr/siren/#{label}" } do
      it_behaves_like 'happy path', siren
    end
  end

  #  context 'DEBUG', vcr: { cassette_name: 'api_insee_fr/siren/active_GE_bis' } do
  #    it_behaves_like 'happy path', sirens_insee_v3[:active_GE_bis]
  #  end

  # TODO: INSEE if pays != France TVA intracommu is null else not null !
  shared_examples 'ENFORCED SPECS' do |siren, expected_json|
    subject do
      get :show, params: { siren: siren, token: token }.merge(mandatory_params)
      JSON.parse(response.body)
    end

    let(:siren) { siren }
    let(:expected_json) { expected_json }

    it 'includes expected values' do
      expect(subject).to include_json(expected_json)
    end
  end

  describe 'checks json of active_GE', vcr: { cassette_name: 'api_insee_fr/siren/active_GE' } do
    it_behaves_like 'ENFORCED SPECS', sirens_insee_v3[:active_GE], JSON.parse(File.read('spec/support/payload_files/json/entreprise_restored_active_GE.json'))
  end

  describe 'checks json of active_AE', vcr: { cassette_name: 'api_insee_fr/siren/active_AE' } do
    # if AE: raison sociale = raison sociale | nomS+prenomS
    it_behaves_like 'ENFORCED SPECS', sirens_insee_v3[:active_AE], JSON.parse(File.read('spec/support/payload_files/json/entreprise_restored_active_AE.json'))
  end

  describe 'checks json of etranger', vcr: { cassette_name: 'api_insee_fr/siren/etranger' } do
    it_behaves_like 'ENFORCED SPECS', sirens_insee_v3[:etranger], { entreprise: { numero_tva_intracommunautaire: nil } }
  end

  describe 'checks json with enseigne', vcr: { cassette_name: 'api_insee_fr/siren/with_enseigne_siren' } do
    it_behaves_like 'ENFORCED SPECS', sirens_insee_v3[:with_enseigne_siren], { entreprise: { enseigne: 'GCSPA' } }
  end

  describe 'checks json when ceased', vcr: { cassette_name: 'api_insee_fr/siren/ceased' } do
    it_behaves_like 'ENFORCED SPECS', ceased_siren, { entreprise: { etat_administratif: { value: 'C', date_cessation: 1_315_173_600 } } }
    it_behaves_like 'ENFORCED SPECS', ceased_siren, { etablissement_siege: { etat_administratif: { value: 'F', date_fermeture: 1_315_173_600 } } }
  end
end
