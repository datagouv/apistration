require 'rails_helper'

RSpec.describe 'Admin: facilitators password', app: :api_entreprise do
  let(:password) { 'mot-de-passe-des-facilitateurs' }

  before do
    stub_credential(:api_particulier_facilitators_password, password)
  end

  it 'lets an admin copy the masked password and the page url' do
    login_as(create(:user, :admin))

    visit admin_users_path
    click_on 'Facilitateurs'

    expect(page).to have_field('Mot de passe', with: password, type: 'password')
    expect(page).to have_button('Copier le mot de passe')
    expect(page).to have_link("#{APIParticulier::BASE_URL}/facilitateurs")
  end

  describe 'copy button', :js do
    before do
      login_as(create(:user, :admin))
      visit admin_facilitators_path
      page.execute_script(<<~JS)
        document.addEventListener('copy', () => { window.copiedText = document.getSelection().toString() })
      JS
    end

    it 'copies the password and keeps it masked' do
      accept_alert('Mot de passe copié') { click_on 'Copier le mot de passe' }

      expect(page.evaluate_script('window.copiedText')).to eq(password)
      expect(page).to have_field('Mot de passe', type: 'password')
    end

    it 'keeps the password masked when the browser fails to copy it' do
      page.execute_script("document.execCommand = () => { throw new Error('copy refused') }")

      click_on 'Copier le mot de passe'

      expect(page).to have_field('Mot de passe', type: 'password')
    end
  end

  it 'hides the password from a user who is not an admin' do
    login_as(create(:user))

    visit admin_facilitators_path

    expect(page).to have_current_path(root_path, ignore_query: true)
    expect(page.html).not_to include(password)
  end

  it 'hides the password from a visitor' do
    visit admin_facilitators_path

    expect(page).to have_current_path(login_path, ignore_query: true)
    expect(page.html).not_to include(password)
  end
end
