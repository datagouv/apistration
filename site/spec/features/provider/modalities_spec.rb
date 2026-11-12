RSpec.describe 'Provider: success by calling modality', app: :api_particulier do
  let(:user) { create(:user, provider_uids: %w[cnous education_nationale cnav]) }

  before do
    login_as(user)
  end

  def create_calls(controller, statuses)
    statuses.each do |status|
      create(:access_log, controller: "api_particulier/v3_and_more/#{controller}", status:, api_version: 'v3', cached: false, duration: '100')
    end
  end

  describe 'provider whose endpoint is callable by identity, INE and FranceConnect' do
    before do
      create_calls('cnous/etudiant_boursier_with_civility', %w[200 404 404 404])
      create_calls('cnous/etudiant_boursier_with_ine', %w[200 200 200 404])
      create_calls('cnous/etudiant_boursier_with_france_connect', %w[200 502])
    end

    it 'compares the number of calls and the success, not found and provider error rates of each modality' do
      visit provider_dashboard_success_path(provider_uid: 'cnous')

      within_table('Appels par modalité d\'appel') do
        expect(page).to have_css('thead tr', text: 'Modalité d\'appel Appels Succès Non trouvés Erreurs fournisseur')
        expect(page).to have_css('tbody th[scope="row"]', count: 3)
        expect(page).to have_css('tbody tr:nth-child(1)', text: 'Identité 4 25,00% 75,00% 0,00%')
        expect(page).to have_css('tbody tr:nth-child(2)', text: 'INE 4 75,00% 25,00% 0,00%')
        expect(page).to have_css('tbody tr:nth-child(3)', text: 'FranceConnect 2 50,00% 0,00% 50,00%')
      end
    end

    it 'draws the rates of each modality as a stacked bar of percentages' do
      visit provider_dashboard_success_path(provider_uid: 'cnous')

      chart = find('bar-chart[unit-tooltip="%"]')

      expect(JSON.parse(chart[:x])).to eq([%w[Identité INE FranceConnect]])
      expect(JSON.parse(chart[:y])).to eq([[25.0, 75.0, 50.0], [75.0, 25.0, 0.0], [0.0, 0.0, 50.0]])
    end

    it 'lists a modality nobody called over the period, without any rate' do
      visit provider_dashboard_success_path(provider_uid: 'cnous', filter: { date_from: 3.months.ago.to_date, date_to: 2.months.ago.to_date })

      within_table('Appels par modalité d\'appel') do
        expect(page).to have_css('tbody tr:nth-child(3)', exact_text: 'FranceConnect 0')
      end
    end

    it 'does not repeat the comparison per endpoint when a single endpoint is concerned' do
      visit provider_dashboard_success_path(provider_uid: 'cnous')

      expect(page).to have_table('Appels par modalité d\'appel')
      expect(page).to have_no_table('Appels par endpoint et modalité d\'appel')
    end
  end

  describe 'provider with several endpoints callable through several modalities' do
    before do
      create_calls('cnav/quotient_familial_with_civility', %w[200 404])
      create_calls('cnav/quotient_familial_with_france_connect', %w[200])
      create_calls('cnav/prime_activite_with_civility', %w[404])
    end

    it 'details the comparison per endpoint' do
      visit provider_dashboard_success_path(provider_uid: 'cnav')

      within_table('Appels par endpoint et modalité d\'appel') do
        expect(page).to have_css('tbody tr', text: 'Quotient familial CAF & MSA Identité 2 50,00% 50,00% 0,00%')
        expect(page).to have_css('tbody tr', text: 'Quotient familial CAF & MSA FranceConnect 1 100,00% 0,00% 0,00%')
        expect(page).to have_css('tbody tr', exact_text: 'Statut prime d\'activité FranceConnect 0')
        expect(page).to have_css('tbody tr:first-child th[scope="row"]', count: 2)
      end
    end
  end

  describe 'provider whose endpoints have a single modality' do
    before do
      create_calls('men/scolarites_with_civility', %w[200 404])
    end

    it 'shows no comparison by modality' do
      visit provider_dashboard_success_path(provider_uid: 'education_nationale')

      expect(page).to have_css('h2', text: 'Répartition succès / non-trouvés / erreurs')
      expect(page).to have_no_text('Par modalité d\'appel')
    end
  end
end
