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
