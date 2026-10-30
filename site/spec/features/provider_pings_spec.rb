require 'rails_helper'

RSpec.describe 'Provider pings page', :js do
  shared_examples 'a provider pings page' do |namespace, pings_url, ping_url_prefix|
    let(:provider_pings) { ProviderPings.new(namespace) }
    let(:up_url) { "#{ping_url_prefix}/up" }
    let(:down_url) { "#{ping_url_prefix}/down" }
    let(:maintenance_url) { "#{ping_url_prefix}/maintenance" }

    before do
      stub_request(:get, pings_url).to_return(
        status: 200,
        body: [
          { name: 'Up provider', url: up_url },
          { name: 'Down provider', url: down_url },
          { name: 'Maintenance provider', url: maintenance_url }
        ].to_json
      )
      stub_request(:get, up_url).to_return(status: 200, body: { status: 'ok', last_update: '2026-10-29T10:00:00Z' }.to_json)
      stub_request(:get, down_url).to_return(status: 502, body: { status: 'bad_gateway', last_update: '2026-10-29T10:00:00Z', last_ok_status: '2026-10-28T08:00:00Z' }.to_json)
      stub_request(:get, maintenance_url).to_return(status: 200, body: { status: 'maintenance', last_update: '2026-10-29T10:00:00Z' }.to_json)
    end

    it 'shows each provider with its status, its last check and its ping route' do
      visit '/developpeurs/etat-des-fournisseurs'

      within('tr', text: 'Up provider') do
        expect(page).to have_css('.fr-badge--success', text: /\ADisponible\z/i)
        expect(page).to have_text('29/10/2026 à 11:00:00')
        expect(page).to have_link(href: up_url)
      end

      within('tr', text: 'Down provider') do
        expect(page).to have_css('.fr-badge--error', text: /\AIndisponible\z/i)
        expect(page).to have_text('Dernier statut disponible le 28/10/2026 à 09:00:00')
      end

      within('tr', text: 'Maintenance provider') do
        expect(page).to have_css('.fr-badge--warning', text: /\AEn maintenance\z/i)
      end

      expect(page).not_to expose_window_opener
    end

    it 'lists failing providers first, then those under maintenance' do
      visit '/developpeurs/etat-des-fournisseurs'

      expect(page).to have_css('.fr-badge--success')
      expect(all('tbody th').map(&:text)).to eq(['Down provider', 'Maintenance provider', 'Up provider'])
    end

    it 'sums up failing and maintenance providers above the list' do
      visit '/developpeurs/etat-des-fournisseurs'

      expect(page).to have_css('.fr-alert--error', text: '1 fournisseur indisponible et 1 fournisseur en maintenance')
    end

    it 'tells the user when every provider works' do
      stub_request(:get, down_url).to_return(status: 200, body: { status: 'ok' }.to_json)
      stub_request(:get, maintenance_url).to_return(status: 200, body: { status: 'ok' }.to_json)

      visit '/developpeurs/etat-des-fournisseurs'

      expect(page).to have_css('.fr-alert--success', text: 'Tous les fournisseurs fonctionnent normalement.')
    end

    it 'announces the summary in a status region present before the checks end' do
      visit '/developpeurs/etat-des-fournisseurs'

      expect(page).to have_css('[role=status] .fr-alert--error', text: '1 fournisseur indisponible')
      expect(page).to have_no_css('turbo-frame [role=status]')
    end

    it 'reports a provider as unavailable when its ping does not answer' do
      stub_request(:get, up_url).to_timeout

      visit '/developpeurs/etat-des-fournisseurs'

      within('tr', text: 'Up provider') do
        expect(page).to have_css('.fr-badge--error', text: /\AIndisponible\z/i)
      end
    end

    it 'reports a provider as unavailable when its ping answers a malformed HTTP response, without hiding the others' do
      stub_request(:get, up_url).to_raise(Net::HTTPBadResponse)

      visit '/developpeurs/etat-des-fournisseurs'

      within('tr', text: 'Up provider') do
        expect(page).to have_css('.fr-badge--error', text: /\AIndisponible\z/i)
      end

      within('tr', text: 'Maintenance provider') do
        expect(page).to have_css('.fr-badge--warning', text: /\AEn maintenance\z/i)
      end
    end

    it 'does not report a provider as available when its ping status is unknown or unreadable' do
      stub_request(:get, up_url).to_return(status: 200, body: { status: 'unknown' }.to_json)
      stub_request(:get, maintenance_url).to_return(status: 200, body: 'not json')

      visit '/developpeurs/etat-des-fournisseurs'

      within('tr', text: 'Up provider') do
        expect(page).to have_css('.fr-badge', text: /\AStatut inconnu\z/i)
      end

      within('tr', text: 'Maintenance provider') do
        expect(page).to have_css('.fr-badge', text: /\AStatut inconnu\z/i)
      end

      expect(page).to have_css('.fr-alert--error', text: '1 fournisseur indisponible et 2 fournisseurs au statut inconnu')
    end

    it 'still checks providers when the cache cannot be written' do
      allow(Rails.cache).to receive(:write).and_return(nil)

      visit '/developpeurs/etat-des-fournisseurs'

      within('tr', text: 'Up provider') do
        expect(page).to have_css('.fr-badge--success', text: /\ADisponible\z/i)
      end
    end

    it 'reports a provider as unavailable when its ping answers too slowly overall' do
      stub_const('ProviderPings::PROBE_DEADLINE', 0.2.seconds)
      stub_request(:get, up_url).to_return(lambda { |_request|
        sleep 1
        { status: 200, body: { status: 'ok' }.to_json }
      })

      visit '/developpeurs/etat-des-fournisseurs'

      within('tr', text: 'Up provider') do
        expect(page).to have_css('.fr-badge--error', text: /\AIndisponible\z/i)
      end
    end

    it 'does not wait again for a provider that just answered too slowly' do
      stub_const('ProviderPings::PROBE_DEADLINE', 0.2.seconds)
      slow_ping = stub_request(:get, up_url).to_return(lambda { |_request|
        sleep 1
        { status: 200, body: { status: 'ok' }.to_json }
      })

      2.times do
        visit '/developpeurs/etat-des-fournisseurs'

        within('tr', text: 'Up provider') do
          expect(page).to have_css('.fr-badge--error', text: /\AIndisponible\z/i)
        end
      end

      expect(slow_ping).to have_been_requested.once
    end

    def while_another_visitor_checks_up_provider
      probe_started = Queue.new
      release_probe = Queue.new
      hold_up_provider_probe(probe_started, release_probe)
      other_visitor = Thread.new { provider_pings.checks }
      raise 'the other visitor never probed the provider' unless probe_started.pop(timeout: 5)

      yield lambda {
        release_probe << true
        other_visitor.join
      }
    ensure
      release_probe << true
      other_visitor&.join(10)
    end

    def hold_up_provider_probe(probe_started, release_probe)
      stub_request(:get, up_url).to_return(lambda { |_request|
        probe_started << true
        release_probe.pop(timeout: 10)
        { status: 200, body: { status: 'ok' }.to_json }
      })
    end

    it 'shows the status of a provider that another visitor was checking, once checked' do
      while_another_visitor_checks_up_provider do |end_other_visitor_check|
        visit '/developpeurs/etat-des-fournisseurs'

        expect(page).to have_css('[role=status] .fr-alert', text: '1 fournisseur en cours de vérification')

        end_other_visitor_check.call

        within('tr', text: 'Up provider') do
          using_wait_time(6) { expect(page).to have_css('.fr-badge--success', text: /\ADisponible\z/i) }
        end
      end
    end

    it 'checks again a provider whose reload failed on the network' do
      while_another_visitor_checks_up_provider do |end_other_visitor_check|
        visit '/developpeurs/etat-des-fournisseurs'
        expect(page).to have_css('[role=status] .fr-alert', text: '1 fournisseur en cours de vérification')

        page.execute_script(<<~JS)
          const originalFetch = window.fetch;
          window.fetch = () => {
            window.fetch = originalFetch;
            window.reloadFailed = true;
            return Promise.reject(new TypeError('network down'));
          };
        JS
        Timeout.timeout(6) { sleep 0.1 until page.evaluate_script('window.reloadFailed') }
        end_other_visitor_check.call

        within('tr', text: 'Up provider') do
          using_wait_time(8) { expect(page).to have_css('.fr-badge--success', text: /\ADisponible\z/i) }
        end
      end
    end

    it 'clears the summary when the list of pings becomes unavailable' do
      while_another_visitor_checks_up_provider do
        visit '/developpeurs/etat-des-fournisseurs'
        expect(page).to have_css('[role=status] .fr-alert', text: '1 fournisseur en cours de vérification')

        Rails.cache.clear
        stub_request(:get, pings_url).to_return(status: 500)

        using_wait_time(6) { expect(page).to have_text('Liste des fournisseurs indisponible') }
        expect(page).to have_no_css('[role=status] .fr-alert')
      end
    end

    it 'tells the user when the list of pings is not a list of pings' do
      stub_request(:get, pings_url).to_return(status: 200, body: 'null')

      visit '/developpeurs/etat-des-fournisseurs'

      expect(page).to have_text('Liste des fournisseurs indisponible')
    end

    it 'does not ask siade again for the list right after failing to retrieve it' do
      list_request = stub_request(:get, pings_url).to_return(status: 500)

      2.times do
        visit '/developpeurs/etat-des-fournisseurs'
        expect(page).to have_text('Liste des fournisseurs indisponible')
      end

      expect(list_request).to have_been_requested.once
    end

    it 'tells the user when the list of pings cannot be retrieved' do
      stub_request(:get, pings_url).to_return(status: 500)

      visit '/developpeurs/etat-des-fournisseurs'

      expect(page).to have_text('Liste des fournisseurs indisponible')
    end
  end

  context 'with API Entreprise', app: :api_entreprise do
    it_behaves_like 'a provider pings page', 'api_entreprise', APIEntreprise::PINGS_URL, "#{APIEntreprise::BASE_URL}/ping"
  end

  context 'with API Particulier', app: :api_particulier do
    it_behaves_like 'a provider pings page', 'api_particulier', APIParticulier::PINGS_URL, "#{APIParticulier::BASE_URL}/api"
  end
end
