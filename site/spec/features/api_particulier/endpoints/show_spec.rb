# frozen_string_literal: true

require 'rails_helper'
require_relative '../../../support/shared_examples/features/endpoints/show'

RSpec.describe 'Endpoints show', app: :api_particulier do
  let(:api_status) { 200 }
  let(:uid) { 'cnav/quotient_familial' }
  # API Particulier specific tests
  let(:endpoint) { APIParticulier::Endpoint.find(uid) }

  before do
    stub_request(:get, endpoint.ping_url).to_return(status: api_status) if endpoint.ping_url
    visit endpoint_path(uid:)
  end

  it_behaves_like 'an endpoints show feature', APIParticulier, 'cnav/quotient_familial', 'JEAN JACQUES'

  it 'displays attributes data' do
    expect(page).to have_css('#property_attribute_allocataires')
  end

  describe 'alert' do
    let(:uid) { 'cnav/psu' }

    it 'keeps the formatting of the title' do
      expect(page).to have_css('.fr-alert__title i', text: 'année du calcul des ressources')
    end
  end

  it "displays cas d'usage" do
    allow(SimplifionsStore.instance).to receive(:for_endpoint).and_return([
      APIParticulier::CasUsage.new(name: 'Tarification cantine scolaire à 1€', url: 'https://simplifions.data.gouv.fr/cas-d-usages/tarification-cantine-scolaire-a-1eur', icon: '🏫', description: nil, administrations: [], public_cible: [])
    ])
    visit endpoint_path(uid:)
    expect(page).to have_text('Tarification cantine')
  end

  describe 'each endpoint V2' do
    APIParticulier::EndpointV2.all.each do |single_endpoint|
      it "works for #{single_endpoint.uid} endpoint" do
        visit endpoint_path(uid: single_endpoint.uid)

        expect(page).to have_css("##{dom_id(single_endpoint)}")
      end
    end
  end

  describe 'provider errors' do
    it 'lists the errors of the endpoint grouped by status' do
      expect(page).to have_css('#erreurs')
      expect(page).to have_text('35003')
      expect(page).to have_text('35560')
    end

    it 'links to the nomenclature filtered on the endpoint operation' do
      expect(page).to have_link(href: "#{APIParticulier::BASE_URL}/api/errors?operation_id=api_particulier_v3_cnav_quotient_familial_with_civility")
    end

    it 'lists the FranceConnect token errors in their own block' do
      expect(page).to have_css('#erreurs-france-connect')
      expect(page).to have_text('51501')
      expect(page).to have_text('51504')
    end

    it 'shows no INE block on an endpoint without INE modality' do
      expect(page).to have_no_css('#erreurs-ine')
    end

    %w[cnous/statut_etudiant_boursier mesri/statut_etudiant].each do |ine_endpoint_uid|
      context "with #{ine_endpoint_uid}, callable with an INE" do
        let(:uid) { ine_endpoint_uid }

        it 'lists the INE errors in their own block' do
          within('#erreurs-ine + p + *') do
            expect(page).to have_text('00360')
          end
        end
      end
    end

    context 'with an endpoint whose provider has a specific not found' do
      let(:uid) { 'cnav/psu' }

      it 'lists the allocataire not eligible error' do
        expect(page).to have_text('37003')
      end
    end
  end

  describe 'scope badges and scope list' do
    it 'renders a purple badge carrying the raw scope name next to each gated attribute' do
      expect(page).to have_css('#property_attribute_allocataires .fr-badge--purple-glycine', text: 'cnaf_allocataires')
      expect(page).to have_css('#property_attribute_enfants .fr-badge--purple-glycine', text: 'cnaf_enfants')
      expect(page).to have_css('#property_attribute_adresse .fr-badge--purple-glycine', text: 'cnaf_adresse')
      expect(page).to have_css('#property_attribute_quotient_familial .fr-badge--purple-glycine', text: 'cnaf_quotient_familial')
    end

    it "exposes the controller's scopes in a top-level Scopes section below Les données" do
      expect(page).to have_css('h2#scopes')
      expect(page).to have_css('h2#scopes + p + ul li code', text: '(cnaf_quotient_familial)')
      expect(page).to have_css('h2#scopes + p + ul li code', text: '(cnaf_allocataires)')
      expect(page).to have_css('h2#scopes + p + ul li code', text: '(cnaf_enfants)')
      expect(page).to have_css('h2#scopes + p + ul li code', text: '(cnaf_adresse)')
    end

    it 'renders the humanized scope label fetched from DataPass, not the raw scope code' do
      Rails.cache.clear

      stub_request(:get, "#{DataPass::BASE_URL}/api/v1/definitions/api_particulier")
        .to_return(
          status: 200,
          headers: { 'Content-Type' => 'application/json' },
          body: {
            'scopes' => [
              {
                'value' => 'cnaf_quotient_familial',
                'name' => 'Quotient familial CAF & MSA',
                'group' => 'API Quotient familial',
                'provider' => 'CNAF & MSA'
              }
            ]
          }.to_json
        )

      visit endpoint_path(uid:)

      expect(page).to have_css('h2#scopes + p + ul li strong', text: 'Quotient familial CAF & MSA')
    end
  end
end
