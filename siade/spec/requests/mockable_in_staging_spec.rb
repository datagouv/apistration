RSpec.describe 'Mocking in staging for each routes' do
  before do
    allow(Rails.env).to receive(:staging?).and_return(true)
    allow(MockDataBackend).to receive(:get_response_for).and_return(nil)

    Rack::Attack.reset!
  end

  describe 'API Entreprise', api: :entreprise do
    describe 'v3 and more endpoint' do
      it 'renders a 200' do
        get "/v3/ministere_interieur/rna/associations/#{valid_siret}", params: { token: yes_jwt }.merge(mandatory_params)

        assert_response 200
      end
    end

    %w[
      /v2/effectifs_annuels_acoss_covid/000
      /v2/effectifs_mensuels_acoss_covid/2019/01/etablissement/000
      /v2/effectifs_mensuels_acoss_covid/:annee/:mois/entreprise/000
      /v2/exercices/000
      /v2/cotisations_msa/000
      /v2/cartes_professionnelles_fntp/000
      /v2/certificats_opqibi/000
      /v2/liasses_fiscales_dgfip/:annee/complete/000
      /v2/liasses_fiscales_dgfip/:annee/declarations/000
      /v2/liasses_fiscales_dgfip/:annee/dictionnaire
      /v2/attestations_fiscales_dgfip/000
      /v2/attestations_sociales_acoss/000
      /v2/attestations_agefiph/000
      /v2/conventions_collectives/000
      /v2/entreprises_artisanales_cma/000
      /v2/eligibilites_cotisation_retraite_probtp/000
      /v2/attestations_cotisation_retraite_probtp/000
      /v2/certificats_qualibat/000
      /v2/extraits_rcs_infogreffe/000
      /v2/associations/:id
      /v2/documents_associations/:id
      /v2/certificats_cnetp/000
      /v2/certificats_rge_ademe/000
      /v2/extraits_courts_inpi/000
      /v2/bilans_entreprises_bdf/000
      /v2/entreprises/000
      /v2/etablissements/000
      /v2/eori_douanes/:siret_or_eori
    ].each do |path|
      it "works for #{path}" do
        get path, params: { token: yes_jwt }.merge(mandatory_params)
        assert_response 200
      end
    end
  end

  describe 'API Particulier', api: :particulier do
    {
      '/api/v2/composition-familiale' => {
        'numeroAllocataire' => '1234567',
        'codePostal' => '75001'
      },
      '/api/v2/situations-pole-emploi' => {
        'identifiant' => '1234567890'
      },
      '/api/v2/etudiants' => {
        'ine' => '1234567890G'
      },
      '/api/v2/etudiants-boursiers' => {
        'ine' => '1234567890G'
      },
      '/api/v2/scolarites' => {
        'nom' => 'DUPONT',
        'prenom' => 'Jean',
        'sexe' => 'm',
        'dateNaissance' => '1980-01-01',
        'codeEtablissement' => '1234567A',
        'anneeScolaire' => '2019-2020'
      },
      '/api/v2/avis-imposition' => {
        'numeroFiscal' => '1234567890ABC',
        'referenceAvis' => '2134567890ABC'
      },
      '/api/ping' => {}
    }.each do |path, params|
      it "works for #{path}" do
        get path, params: { token: yes_jwt }.merge(params)
        assert_response 200
      end
    end
  end
end
