RSpec.describe SIADE::V2::Drivers::EntreprisesArtisanales, type: :provider_driver do
  subject { described_class.new(siren: siren).perform_request }

  let(:valid_payload) do
    {
      siren:                            siren,
      etablissement_origine_id:         '3',

      modalite_exercice:                'P',
      non_sedentaire:                   '0',
      activite_artisanales_declarees:   'PRESTATION DE SERVICE COMMERCE CREATION ACQUISITION ET EXPLOITATION DE TOUT SALON DE COIFFURE DAMES MANUCURE PEDICURE SOINS DE BEAUTE ESTH',
      denomination_sociale:             'CHRISTIAN LACOUT',
      sigle:                            '',

      declaration_procedures:           '',

      code_cfe:                         'M7501',
      categorie_personne:               'PM',
      libelle_epci:                     'Métropole du Grand Paris',
      code_norme_activite_entreprises:  nil,

      rnm_id:                           19139,
      rnm_numero_gestion:               '179456475',
      rnm_date_import:                  '2019-11-02T09:09:25Z',
      rnm_date_mise_a_jour:             '2021-01-14T02:00:14Z',

      adresse_numero_voie:              '111',
      adresse_indice_repetition_voie:   '',
      adresse_type_voie:                'RUE',
      adresse_libelle_voie:             'DE BELLEVILLE',
      adresse_complement:               '',
      adresse_code_postal:              '75019',
      adresse_commune:                  'PARIS',
      adresse_commune_cog:              '75119',
      adresse_departement:              'PARIS',
      adresse_region:                   'ILE-DE-FRANCE',

      dirigeant_qualification:          'MAITRE ARTISAN',
      dirigeant_nom_de_naissance:       nil,
      dirigeant_nom_usage:              nil,
      dirigeant_prenom1:                nil,
      dirigeant_prenom2:                nil,
      dirigeant_prenom3:                nil,
      dirigeant_pseudonyme:             nil,
      dirigeant_date_de_naissance:      nil,
      dirigeant_lieu_de_naissance:      nil,

      effectif_salarie:                 '12',
      effectif_apprenti:                '0',

      date_immatriculation:             '1964-06-03T12:00:00Z',
      date_radiation:                   nil,
      date_debut_activite:              '1964-03-02T12:00:00Z',
      date_cessation_activite:          nil,
      date_cloture_liquidation:         nil,
      date_transfert_patrimoine:        nil,
      date_dissolution:                 nil,

      code_nafa_principal:              '9602AA',
      code_nafa_secondaire1:            '',
      code_nafa_secondaire2:            '',
      code_nafa_secondaire3:            '',
      code_nafa_libelle:                'Coiffure en salon ',

      secteur_activite_intitule_nar_4:  'SERVICES',
      secteur_activite_intitule_nar_20: 'BLANCHISSERIE, TEINTURERIE, SOINS A LA PERSONNE',

      forme_juridique_id:               '5499',
      forme_juridique_label:            'Société à responsabilité limitée (sans autre indication)',

      eirl_id_registre:                 nil,
      eirl_denomination:                nil,
      eirl_objet_activite:              nil,
      eirl_date_depot:                  nil,
    }
  end

  context 'when siren is not found', vcr: { cassette_name: 'rnm_cma/not_found_siren' } do
    let(:siren) { not_found_siren(:rnm_cma) }

    its(:http_code) { is_expected.to eq(404) }
    its(:errors) { is_expected.to have_error("Le siret ou siren indiqué n'existe pas, n'est pas connu ou ne comporte aucune information pour cet appel") }
  end

  context 'when siren is found', vcr: { cassette_name: 'rnm_cma/valid_siren_json' } do
    let(:siren) { valid_siren(:rnm_cma) }

    its(:http_code) { is_expected.to eq(200) }

    its(:entreprise) do
      is_expected.to eq(valid_payload)
    end

    context 'when there is a missing key in response payload' do
      let(:missing_response_key) { 'gest_emetteur' }
      let(:final_payload_missing_key) { :code_cfe }

      before do
        allow_any_instance_of(described_class).to receive(:response_json).and_wrap_original do |original_method|
          response_json = original_method.call
          response_json.delete missing_response_key
          response_json
        end
      end

      context do
        before do
          subject.entreprise
        end

        its(:http_code) { is_expected.to eq(206) }
      end

      it 'replaces value with placeholder' do
        expect(subject.entreprise[final_payload_missing_key]).to eq('Donnée indisponible')
      end
    end
  end
end
