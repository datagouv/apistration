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
  end
end
