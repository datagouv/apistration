RSpec.describe APIEntreprise::V2::EtablissementsRestoredController, type: :controller do
  before do
    allow_any_instance_of(SIADE::V2::Requests::INSEE::Etablissement).to receive(:insee_token).and_return('not a valid token')
    allow_any_instance_of(SIADE::V2::Requests::INSEE::Entreprise).to receive(:insee_token).and_return('not a valid token')
  end

  it_behaves_like 'unauthorized'
  it_behaves_like 'forbidden'
  it_behaves_like 'unprocessable_entity', :show, :siret
  it_behaves_like 'ask_for_mandatory_parameters'

  context 'when siret is not found', vcr: { cassette_name: 'insee/siret/non_existent' } do
    it_behaves_like 'not_found'
  end

  context 'without param `with_non_diffusable` it returns 403', vcr: { cassette_name: 'insee/siret/non_diffusable' } do
    subject { get :show, params: { siret: non_diffusable_siret, token: token }.merge(mandatory_params) }

    let(:token) { yes_jwt }

    its(:status) { is_expected.to eq 451 }

    it 'returns 403 with error message' do
      expect(JSON.parse(subject.body)).to have_json_error(
        detail: 'Le SIRET est non diffusable, pour y accéder référez-vous à notre documentation.'
      )
    end
  end

  context 'with param `non_diffusables` it returns 200', vcr: { cassette_name: 'insee/siret/non_diffusable' } do
    subject { get :show, params: { siret: non_diffusable_siret, token: token, non_diffusables: true }.merge(mandatory_params) }

    let(:token) { yes_jwt }
    let(:json) { JSON.parse(subject.body).deep_symbolize_keys }

    its(:status) { is_expected.to eq 200 }

    it 'returns valid payload' do
      expect(json).to match_json_schema('insee/v2/etablissement')
    end

    it 'returns `diffusable` info' do
      expect(json.dig(:etablissement, :diffusable_commercialement)).to eq false
    end
  end

  context 'gateway error still present in error' do
    subject { get :show, params: { siret: siret, token: token }.merge(mandatory_params) }

    let(:token) { yes_jwt }
    let(:siret) { sirets_insee_v3[:active_GE] }

    before do
      allow_any_instance_of(SIADE::V2::Retrievers::EtablissementsRestored).to receive(:retrieve).and_return nil
      allow_any_instance_of(SIADE::V2::Retrievers::EtablissementsRestored).to receive(:success?).and_return false
      allow_any_instance_of(SIADE::V2::Retrievers::EtablissementsRestored).to receive(:http_code).and_return 503
      allow_any_instance_of(SIADE::V2::Retrievers::EtablissementsRestored).to receive(:errors).and_return [ProviderUnknownError.new('INSEE', 'artificial error')]
    end

    its(:status) { is_expected.to eq 503 }

    it 'has errors' do
      expect(JSON.parse(subject.body)).to have_json_error(detail: 'artificial error')
    end
  end

  describe 'siret redirected to another siret', vcr: { cassette_name: 'insee/siret/redirected_v2' } do
    subject { get :show, params: { siret: siret, token: token }.merge(mandatory_params) }

    let(:token) { yes_jwt }
    let(:siret) { redirected_siret }

    its(:status) { is_expected.to eq 301 }
    its(:location) { is_expected.to include "/v2/etablissements/77887067500015?#{mandatory_params.to_param}&token=#{token}" }
    its(:body) { is_expected.to match(%r{Vous êtes.+redirigé.+Le siren/siret demandé est un doublon et ne doit plus être utilisé.+Référez-vous à notre.+documentation.+pour plus de détails}m) }
  end

  shared_examples 'happy path' do |siret|
    subject(:json) do
      get :show, params: { siret: siret, token: token }.merge(mandatory_params)
      JSON.parse(response.body).deep_symbolize_keys
    end

    let(:token)   { yes_jwt }
    let(:french?) { json[:etablissement][:pays_implantation][:code] == 'FR' }
    let(:adresse) { json[:etablissement][:adresse] }
    let(:commune) { json[:etablissement][:commune_implantation] }
    let(:region)  { json[:etablissement][:region_implantation] }
    let(:pays)    { json[:etablissement][:pays_implantation] }

    # Warning this test allow a LOT of nullable values (ie: ["null", "string"]) in json schema
    it { is_expected.to match_json_schema('insee/v2/etablissement') }

    it 'has a *CODE* commune only if french' do
      if french?
        # https://github.com/etalab/api-communes/issues/10
        # generates 4 errors for Paris/Marseille arrondissements
        expect(commune[:code]).not_to be_nil
      else
        expect(commune[:code]).to be_nil
      end
    end

    it 'has always a *VALUE* commune if french' do # can have a value for foreign adresses
      if french?
        # https://github.com/etalab/api-communes/issues/10
        # generates 2 errors for Paris/Marseille arrondissements
        expect(commune[:value]).to be_not_nil.and not_eq('Donnée indisponible')
      end
    end

    it 'has a region only if french' do
      if french?
        expect(region[:code]).not_to be_nil
        expect(region[:value]).to be_not_nil.and not_eq('Donnée indisponible')
      else
        expect(region[:code]).to be_nil
        expect(region[:value]).to be_nil
      end
    end

    it 'has coherent pays & code_pays' do
      if french?
        expect(pays[:code]).to eq 'FR'
        expect(pays[:value]).to eq 'FRANCE'
      else
        expect(pays[:code]).to be_not_nil.and not_eq 'FR'
        expect(pays[:value]).to be_not_nil.and not_eq 'FRANCE'
      end
    end

    it 'has mandatory fields if french' do
      if french?
        expect(adresse[:code_postal]).not_to be_nil
        expect(adresse[:code_insee_localite]).not_to be_nil
        expect(adresse[:localite]).not_to be_nil
      end
    end
  end

  sirets_insee_v3.each do |label, siret|
    context "well formated #{label}: #{siret}", vcr: { cassette_name: "insee/siret/#{label}" } do
      it_behaves_like 'happy path', siret
    end
  end

  #    context 'DEBUG', vcr: { cassette_name: 'insee/siret/closed' } do
  #      it_behaves_like 'happy path', sirets_insee_v3[:closed]
  #    end

  shared_examples 'ENFORCED SPECS' do |siret, expected_json|
    subject do
      get :show, params: { siret: siret, token: token }.merge(mandatory_params)
      JSON.parse(response.body)
    end

    let(:token) { yes_jwt }
    let(:siret) { siret }
    let(:expected_json) { expected_json }

    it 'includes expected values' do
      expect(subject).to include_json(expected_json)
    end
  end

  describe 'checks json of active_GE', vcr: { cassette_name: 'insee/siret/active_GE' } do
    it_behaves_like 'ENFORCED SPECS', sirets_insee_v3[:active_GE], JSON.parse(File.read('spec/fixtures/payloads/insee/etablissement_restored_active_GE.json'))
  end

  describe 'checks json of with_enseigne_siret', vcr: { cassette_name: 'insee/siret/with_enseigne_siret' } do
    it_behaves_like 'ENFORCED SPECS', sirets_insee_v3[:with_enseigne_siret], { etablissement: { enseigne: 'DOMAINE DAVID BIENFAIT' } }
  end

  describe 'checks json of etranger_1', vcr: { cassette_name: 'insee/siret/etranger_1' } do
    it_behaves_like 'ENFORCED SPECS', sirets_insee_v3[:etranger_1], { etablissement: { adresse: { localite: 'LONDRES' } } }
    it_behaves_like 'ENFORCED SPECS', sirets_insee_v3[:etranger_1], { etablissement: { commune_implantation: { value: 'LONDRES' } } }
  end

  describe 'checks json of closed siret', vcr: { cassette_name: 'insee/siret/closed' } do
    it_behaves_like 'ENFORCED SPECS', closed_siret, { etablissement: { etat_administratif: { value: 'F', date_fermeture: 1_315_173_600 } } }
  end

  context 'adresses re-mapping' do
    shared_examples 'expected adresse' do |siret_sym, l1, l2, l3, l4, l5, l6, l7|
      subject(:json) do
        get :show, params: { siret: siret, token: token }.merge(mandatory_params)
        JSON.parse(response.body).deep_symbolize_keys[:etablissement][:adresse]
      end

      let(:siret) { sirets_insee_v3[siret_sym] }
      let(:token) { yes_jwt }

      describe "RNVP adresse #{siret_sym}: #{sirets_insee_v3[siret_sym]}", vcr: { cassette_name: "insee/siret/#{siret_sym}" } do
        its([:l1]) { is_expected.to eq l1 }
        its([:l2]) { is_expected.to eq l2 }
        its([:l3]) { is_expected.to eq l3 }
        its([:l4]) { is_expected.to eq l4 }
        its([:l5]) { is_expected.to eq l5 }
        its([:l6]) { is_expected.to eq l6 }
        its([:l7]) { is_expected.to eq l7 }
      end
    end

    it_behaves_like 'expected adresse', :address_complete, 'SIMON', 'LE JARDIN DE LEATITIA', 'CTRE COMMERCIAL CARRFOUR', 'N 3 PARIS A METZ', nil, '77410 CLAYE SOUILLY', 'FRANCE'
    it_behaves_like 'expected adresse', :address_poor,        'THOMAS PIERR', nil, nil, '31 AV DU MAINE', nil, '75015 PARIS 15', 'FRANCE'
    it_behaves_like 'expected adresse', :active_AE,           'MADAME ODILE BAROIN', nil, nil, 'SOUVERT', nil, '71540 CHISSEY EN MORVAN', 'FRANCE'
    it_behaves_like 'expected adresse', :artisan,             'ARTISAN', nil, nil, 'LD MASSOULET', nil, '24550 BESSE', 'FRANCE'
    it_behaves_like 'expected adresse', :etranger_3,          'SCI GREJEAN', nil, 'BP 75', '28 BD DE BELGIQUE', nil, 'MONACO', 'MONACO'

    # sigle/enseigne not in l1 !
    # compared to original v2/etablissement l2 & l3 are switched... this one seems to be the only exception detected...
    # l2 : raison sociale | enseignes
    it_behaves_like 'expected adresse', :with_enseigne_siret, 'MONSIEUR DAVID BIENFAIT', 'DOMAINE DAVID BIENFAIT', 'PETIT BUSSIERES', 'RUE DE L\'ETANG', nil, '71960 BUSSIERES', 'FRANCE'
  end
end
