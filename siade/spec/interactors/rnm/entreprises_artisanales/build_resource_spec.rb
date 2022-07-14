RSpec.describe RNM::EntreprisesArtisanales::BuildResource, type: :build_resource do
  describe '.call', vcr: { cassette_name: 'rnm_cma/valid_siren_json' } do
    subject { described_class.call(response:) }

    let(:valid_payload) do
      {
        etablissement_origine_id: '3',

        modalite_exercice: 'P',
        non_sedentaire: '0',
        activite_artisanales_declarees: 'PRESTATION DE SERVICE COMMERCE CREATION ACQUISITION ET EXPLOITATION DE TOUT SALON DE COIFFURE DAMES MANUCURE PEDICURE SOINS DE BEAUTE ESTH',
        denomination_sociale: 'CHRISTIAN LACOUT',
        sigle: '',

        declaration_procedures: '',

        code_cfe: 'M7501',
        categorie_personne: 'PM',
        libelle_epci: 'Métropole du Grand Paris',
        code_norme_activite_entreprises: nil,

        rnm_id: 19_139,
        rnm_numero_gestion: '179456475',
        rnm_date_import: '2019-11-02T09:09:25Z',
        rnm_date_mise_a_jour: '2021-01-14T02:00:14Z',

        adresse_id: '301123626',
        adresse: {
          id: '301123626',
          numero_voie: '111',
          indice_repetition_voie: '',
          type_voie: 'RUE',
          libelle_voie: 'DE BELLEVILLE',
          complement: '',
          code_postal: '75019',
          commune: 'PARIS',
          commune_cog: '75119',
          departement: 'PARIS',
          region: 'ILE-DE-FRANCE'
        },

        dirigeant_qualification: 'MAITRE ARTISAN',
        dirigeant_nom_de_naissance: nil,
        dirigeant_nom_usage: nil,
        dirigeant_prenom1: nil,
        dirigeant_prenom2: nil,
        dirigeant_prenom3: nil,
        dirigeant_pseudonyme: nil,
        dirigeant_date_de_naissance: nil,
        dirigeant_lieu_de_naissance: nil,

        effectif_salarie: '12',
        effectif_apprenti: '0',

        date_immatriculation: '1964-06-03T12:00:00Z',
        date_radiation: nil,
        date_debut_activite: '1964-03-02T12:00:00Z',
        date_cessation_activite: nil,
        date_cloture_liquidation: nil,
        date_transfert_patrimoine: nil,
        date_dissolution: nil,

        code_nafa_principal: '9602AA',
        code_nafa_secondaire1: '',
        code_nafa_secondaire2: '',
        code_nafa_secondaire3: '',
        code_nafa_libelle: 'Coiffure en salon ',

        secteur_activite_intitule_nar_4: 'SERVICES',
        secteur_activite_intitule_nar_20: 'BLANCHISSERIE, TEINTURERIE, SOINS A LA PERSONNE',

        forme_juridique_id: '5499',
        forme_juridique_label: 'Société à responsabilité limitée (sans autre indication)',

        eirl_id_registre: nil,
        eirl_denomination: nil,
        eirl_objet_activite: nil,
        eirl_date_depot: nil
      }
    end

    let(:response) do
      instance_double(Net::HTTPOK, body:)
    end

    let(:body) do
      RNM::EntreprisesArtisanales::MakeRequest.call(params:).response.body
    end

    let(:params) do
      {
        siren: valid_siren(:rnm_cma)
      }
    end

    it { is_expected.to be_a_success }

    it 'builds valid resource' do
      resource = subject.bundled_data.data

      expect(resource).to be_a(Resource)

      expect(resource.to_h).to eq(valid_payload)
    end
  end
end
