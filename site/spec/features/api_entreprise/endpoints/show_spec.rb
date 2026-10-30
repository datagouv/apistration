# frozen_string_literal: true

require 'rails_helper'
require_relative '../../../support/shared_examples/features/endpoints/show'

RSpec.describe 'Endpoints show', app: :api_entreprise do
  let(:api_status) { 200 }
  let(:uid) { 'insee/unites_legales' }
  # API Entreprise specific tests
  let(:endpoint) { APIEntreprise::Endpoint.find(uid) }

  before do
    stub_request(:get, endpoint.ping_url).to_return(status: api_status) if endpoint.ping_url
    visit endpoint_path(uid:)
  end

  it_behaves_like 'an endpoints show feature', APIEntreprise, 'insee/unites_legales', '"sigle": "DINUM"'

  it 'displays attributes data' do
    expect(page).to have_css('#property_attribute_type')

    within('#property_attribute_type') do
      expect(page).to have_text('Indique si l’unité légale est une personne morale ou une personne physique.')
    end
  end

  describe 'attribute description written in Markdown' do
    let(:uid) { 'insee/etablissements' }

    it 'renders its list and named link, and still links its bare URLs' do
      within('#property_unite_legale_economie_sociale_et_solidaire') do
        expect(page).to have_css('li', text: 'poursuivre un but social')
        expect(page).to have_no_text('* poursuivre')
        expect(page).to have_link('Article 1 de la loi n° 2014-856 du 31 juillet 2014', href: 'https://www.legifrance.gouv.fr/loda/article_lc/LEGIARTI000029314926')
        expect(page).to have_link(href: 'https://portail-api.insee.fr/catalog/api/2ba0e549-5587-3ef1-9082-99cd865de66f/doc?page=2ed989b6-001c-4b22-9989-b6001c6b224e#economiesocialesolidaireunitelegale')
      end
    end
  end

  describe 'attribute description holding a pipe' do
    let(:uid) { 'dgfip/liens_capitalistiques' }

    it 'reads as a sentence, not as a table' do
      expect(page).to have_text('Numéro de l’adresse (nref personne morale: 304862, 304872)')
      expect(page).to have_no_css('.description table')
    end
  end

  describe 'attribute description linking another API' do
    let(:uid) { 'insee/etablissements' }

    it 'links to its catalogue sheet' do
      within(first('#property_tranche_effectif_salarie_code')) do
        expect(page).to have_link('API Effectifs - URSSAF Caisse nationale', href: 'https://entreprise.api.gouv.fr/catalogue/gip_mds/effectifs_mensuels_etablissement')
      end
    end
  end

  it "displays links to cas d'usage" do
    allow(SimplifionsStore.instance).to receive(:for_endpoint).and_return([
      APIEntreprise::CasUsage.new(name: 'Marchés publics', url: 'https://simplifions.data.gouv.fr/cas-d-usages/marches-publics', icon: nil, description: nil, administrations: [], public_cible: [])
    ])
    visit endpoint_path(uid:)
    expect(page).to have_link('Marchés publics', href: 'https://simplifions.data.gouv.fr/cas-d-usages/marches-publics')
  end

  describe 'alert' do
    let(:uid) { 'siaf/fondations' }

    it 'displays the title' do
      expect(page).to have_css('.fr-alert__title', text: 'API disponible uniquement en environnement de test')
    end
  end

  describe 'not yet implemented endpoint' do
    let(:uid) { 'agence_bio/certifications_bio' }

    it 'displays the disclaimer' do
      expect(page).to have_css('.fr-alert--error .fr-alert__title', text: "Cette API n'est pas encore implémentée en V.3.")
    end
  end

  it 'displays a link to Socle de base for included endpoints' do
    expect(page).to have_link('Socle de base DLNUF', href: cas_usage_path(uid: 'socle_de_base'))
  end

  describe 'provider errors' do
    context 'with an endpoint whose provider has specific errors' do
      let(:uid) { 'urssaf/attestation_vigilance' }

      it 'lists them under their status' do
        expect(page).to have_css('#erreurs')
        expect(page).to have_text('04501')
        expect(page).to have_text('04502')
      end

      it 'links to the nomenclature filtered on the endpoint operation' do
        operation_id = APIEntreprise::Endpoint.find(uid).operation_id

        expect(page).to have_link(href: "#{APIEntreprise::BASE_URL}/v3/errors?operation_id=#{operation_id}")
      end
    end

    context 'with an endpoint whose provider has a specific not found' do
      let(:uid) { 'cibtp/attestations_cotisations_conges_payes_chomage_intemperies' }

      it 'lists it under the 404 status' do
        expect(page).to have_text('38422')
      end
    end

    context 'with an endpoint whose provider has no specific error' do
      let(:uid) { 'fabrique_numerique_ministeres_sociaux/conventions_collectives' }

      it 'still lists the errors common to every endpoint' do
        expect(page).to have_css('#erreurs')
        expect(page).to have_text('14003')
      end
    end
  end

  describe 'actions' do
    describe 'click on example with collection uid', :js do
      it 'open modal with custom example' do
        visit endpoint_path(uid: 'infogreffe/mandataires_sociaux')

        click_link 'example_link'

        within('#main-modal-content') do
          expect(page).to have_text('"type": "personne_morale"')
          expect(page).to have_text('"type": "personne_physique"')
        end
      end
    end

    describe 'click on cgu', :js do
      it 'opens modal with CGU content' do
        click_link 'cgu_link'

        within('#main-modal-content') do
          expect(page).to have_text('Conditions générales')
        end
      end
    end
  end
end
