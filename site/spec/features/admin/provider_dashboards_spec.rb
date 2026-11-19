RSpec.describe 'Admin: provider dashboards', app: :api_entreprise do
  let(:admin) { create(:user, :admin) }

  before do
    login_as(admin)
  end

  describe 'index page' do
    it 'displays the providers list linked to API Entreprise' do
      visit admin_provider_dashboards_path

      expect(page).to have_text('Tableaux de bords des fournisseurs')

      expect(page).to have_text('INSEE')
      expect(page).to have_no_text('France Travail')
    end

    it 'lists each provider users, loaded in a single query' do
      create(:user, email: 'insee-agent@example.gouv.fr', provider_uids: %w[insee])
      create(:user, email: 'dgfip-agent@example.gouv.fr', provider_uids: %w[dgfip])
      create(:user, email: 'no-provider@example.gouv.fr')

      provider_users_queries = []
      track_provider_users_queries = lambda do |*, payload|
        provider_users_queries << payload[:sql] if payload[:sql].match?(/WHERE.*provider_uids/)
      end

      ActiveSupport::Notifications.subscribed(track_provider_users_queries, 'sql.active_record') do
        visit admin_provider_dashboards_path
      end

      expect(provider_users_queries.size).to eq(1)
      expect(provider_row('INSEE')).to have_text('insee-agent@example.gouv.fr')
      expect(provider_row('INSEE')).to have_no_text('dgfip-agent@example.gouv.fr')
      expect(provider_row('DGFIP')).to have_text('dgfip-agent@example.gouv.fr')
      expect(page).to have_no_text('no-provider@example.gouv.fr')
    end
  end

  def provider_row(name)
    find('tbody tr', text: name, match: :first)
  end

  describe 'show page' do
    it 'renders the provider dashboard page' do
      visit admin_provider_dashboards_path

      first(:link, 'Tableau de bord').click

      expect(page).to have_css('h1')
      expect(page).to have_css('form')
      expect(page).to have_text('Date de début')
    end
  end

  describe 'success section' do
    it 'colors successes green and errors warm on its charts' do
      visit success_section_admin_provider_dashboard_path('insee')

      expect(page).to have_css('bar-chart[selected-palette="divergentAscending"]', count: 2)
    end
  end

  describe 'all providers page' do
    it 'renders the global dashboard with all endpoints' do
      visit admin_provider_dashboard_path('all')

      expect(page).to have_css('h1', text: 'Tous les fournisseurs')
      expect(page).to have_css('form')
      expect(page).to have_text('Date de début')
    end

    it 'is accessible from the index page' do
      visit admin_provider_dashboards_path

      click_link 'Tableau de bord global (tous les fournisseurs)'

      expect(page).to have_css('h1', text: 'Tous les fournisseurs')
    end
  end
end
