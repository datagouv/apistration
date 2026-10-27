RSpec.describe 'Admin: statistics', app: :api_entreprise do
  let(:admin) { create(:user, :admin) }

  before { login_as(admin) }

  it 'renders every statistics page' do
    visit admin_statistics_path

    Admin::StatisticsController::PAGES.each_value do |meta|
      visit admin_statistics_path
      click_link meta[:title]

      expect(page).to have_css('h1')
    end
  end

  it 'sends the status and consumers of an API to the provider dashboards' do
    visit admin_statistics_path

    click_link 'Statut et consommateurs d\'une API'

    expect(page).to have_css('h1', text: 'Tous les fournisseurs')
  end

  it 'finds the clients of an editor, then the consumption of one of their tokens' do
    client = create(:user, email: 'client@commune.fr')
    authorization_request = create(:authorization_request, :with_demandeur, demandeur: client, api: 'particulier', demarche: 'editeur-x')
    token = create(:token, authorization_request:)
    create(:access_log, controller: 'api_particulier/v3_and_more/cnav/quotient_familial', status: '200', token:, timestamp: 2.days.ago)

    visit admin_statistic_path(page: :user_status)
    select 'editeur-x (1)', from: 'Éditeur (démarche)'
    click_button 'Appliquer'

    expect(page).to have_text('client@commune.fr')

    click_link 'Consommation'

    expect(page).to have_css('h1', text: 'Consommation d\'un token')

    visit find('turbo-frame#recent_requests', visible: :all)[:src]

    expect(page).to have_css('td', text: 'api_particulier/v3_and_more/cnav/quotient_familial')
  end
end
