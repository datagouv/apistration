RSpec.describe 'OpenAPI integrity check for v2 APIs', api: :entreprise do
  before do
    allow(Rails.env).to receive(:staging?).and_return(true)
    Rack::Attack.reset!
  end

  it 'renders not implemented error for v3_and_more endpoints' do
    get '/v3/ministere_interieur/rna/associations/00000', params: { token: yes_jwt }.merge(mandatory_params)
    assert_response 501
    expect(response_json.dig(:errors, 0)).to include(code: '00503')
  end

  %w[
    /v2/effectifs_annuels_acoss_covid/000
    /v2/effectifs_mensuels_acoss_covid/2019/01/etablissement/000
    /v2/effectifs_mensuels_acoss_covid/:annee/:mois/entreprise/000
    /v2/exercices/000
    /v2/cotisations_msa/000
    /v2/cartes_professionnelles_fntp/000
    /v2/certificats_opqibi/000
    /v2/certificats_agence_bio/000
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
    /v2/actes_inpi/000
    /v2/bilans_inpi/000
    /v2/bilans_entreprises_bdf/000
    /v2/entreprises/000
    /v2/etablissements/000
    /v2/eori_douanes/:siret_or_eori
  ].each do |path|
    it "mocks #{path} with example" do
      get path, params: { token: yes_jwt }.merge(mandatory_params)
      assert_response 200
    end
  end
end
