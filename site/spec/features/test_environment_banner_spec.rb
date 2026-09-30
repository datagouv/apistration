RSpec.describe 'Test environment banner' do
  context 'when in a bypass login environment' do
    before do
      stub_const('SessionsManagement::BYPASS_LOGIN_ENVIRONMENTS', %w[test])
    end

    it 'is displayed on the public site', app: :api_entreprise do
      visit root_path

      expect(page).to have_css('#test_environment_banner', text: "n'y saisissez aucune donnée personnelle")
    end

    it 'does not mention the anonymization outside staging', app: :api_entreprise do
      visit root_path

      expect(page).to have_css('#test_environment_banner')
      expect(page).to have_no_text('anonymisés')
    end

    it 'explains in staging that emails go to public yopmail inboxes', app: :api_entreprise do
      allow(Rails.env).to receive(:staging?).and_return(true)

      visit root_path

      expect(page).to have_css('#test_environment_banner', text: 'Les emails et noms enregistrés y sont anonymisés')
      expect(page).to have_css('#test_environment_banner', text: 'yopmail')
    end

    it 'is displayed in the admin', app: :api_particulier do
      login_as(create(:user, :admin))

      visit admin_users_path

      expect(page).to have_css('#test_environment_banner')
    end
  end

  context 'when in another environment', app: :api_entreprise do
    it 'is not displayed' do
      visit root_path

      expect(page).to have_css('header[role="banner"]')
      expect(page).to have_no_css('#test_environment_banner')
    end
  end
end
