RSpec.describe 'Admin: activity journal', app: :api_entreprise do
  let(:admin) { create(:user, :admin) }

  before do
    login_as(admin)
  end

  describe 'index' do
    let(:target_user) { create(:user) }
    let!(:impersonation) do
      create(:admin_activity, name: 'impersonation_started', namespace: 'entreprise', admin:, entity: target_user)
    end
    let!(:ban) do
      create(:admin_activity, :token_banned, namespace: 'entreprise', admin:)
    end
    let!(:other_app) do
      create(:admin_activity, name: 'token_created', namespace: 'particulier', admin:)
    end

    before do
      visit admin_admin_activities_path
    end

    it 'lists the activities of the current app only' do
      expect(page).to have_css('.admin-activity', count: 2)
      expect(page).to have_text("Connexion en tant qu'utilisateur")
      expect(page).to have_text('Bannissement de jeton')
      expect(page).to have_text(admin.email)

      within('table') do
        expect(page).to have_no_text('Création de jeton')
      end
    end

    it 'filters by action' do
      select 'Bannissement de jeton', from: 'q_name_eq'
      click_on 'Filtrer'

      expect(page).to have_css('.admin-activity', count: 1)

      within('table') do
        expect(page).to have_text('Bannissement de jeton')
        expect(page).to have_no_text("Connexion en tant qu'utilisateur")
      end
    end
  end

  it 'is reachable from the admin navigation' do
    visit admin_users_path
    click_on 'Journal'

    expect(page).to have_current_path(admin_admin_activities_path)
  end
end
