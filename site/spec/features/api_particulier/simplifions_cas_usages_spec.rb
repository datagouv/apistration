# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Simplifions cas usages', app: :api_particulier do
  let(:endpoint) { APIParticulier::Endpoint.find('cnav/quotient_familial') }

  before do
    stub_request(:get, endpoint.ping_url).to_return(status: 200) if endpoint.ping_url
    stub_simplifions
  end

  describe 'when the cas usages have been refreshed' do
    before do
      Simplifions::RefreshCasUsagesJob.perform_now
      WebMock.reset_executed_requests!
    end

    it 'displays them on the home page without calling Grist' do
      visit root_path

      expect(page).to have_css('#cas-usages', text: 'Tarification cantine scolaire à 1€')
      expect(a_request(:get, /grist\.numerique\.gouv\.fr/)).not_to have_been_made
    end

    it 'displays those of the endpoint dataset on its page without calling Grist' do
      visit endpoint_path(uid: endpoint.uid)

      expect(page).to have_link('Tarification cantine scolaire à 1€', href: 'https://simplifions.data.gouv.fr/demarches/tarification-cantine-scolaire-a-1eur')
      expect(a_request(:get, /grist\.numerique\.gouv\.fr/)).not_to have_been_made
    end

    it 'keeps displaying them while Grist is down' do
      stub_simplifions_grist_failure

      visit root_path

      expect(page).to have_css('#cas-usages', text: 'Tarification cantine scolaire à 1€')
    end
  end

  describe 'when no cas usages have been refreshed yet' do
    it 'displays the endpoint page without cas usages and without calling Grist' do
      visit endpoint_path(uid: endpoint.uid)

      expect(page).to have_css("##{dom_id(endpoint)}")
      expect(page).to have_no_text('Tarification cantine scolaire à 1€')
      expect(a_request(:get, /grist\.numerique\.gouv\.fr/)).not_to have_been_made
    end

    it 'enqueues a refresh of the cas usages' do
      expect { visit root_path }.to have_enqueued_job(Simplifions::RefreshCasUsagesJob)
    end

    it 'still displays the endpoint page when the refresh cannot be enqueued' do
      allow(Simplifions::RefreshCasUsagesJob).to receive(:perform_later).and_raise(ActiveRecord::ConnectionNotEstablished)

      visit endpoint_path(uid: endpoint.uid)

      expect(page).to have_css("##{dom_id(endpoint)}")
    end
  end
end
