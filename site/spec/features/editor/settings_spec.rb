RSpec.describe 'Editor: settings', app: :api_entreprise do
  let(:editor) { create(:editor, :full) }
  let(:user) { create(:user, editor:) }

  before do
    login_as(user)
  end

  describe 'show' do
    before do
      visit editor_settings_path
    end

    it 'prefills the editable profile fields' do
      expect(page).to have_field('Nom', with: editor.name)
      expect(page).to have_field('SIRET', with: editor.siret)
      expect(page).to have_field('Email', with: editor.contact_email)
      expect(page).to have_field('Nom de domaine', with: editor.domain)
    end

    it 'displays the allowed IPs read-only, without an editable field' do
      editor.allowed_ips.each { |ip| expect(page).to have_text(ip) }
      expect(page).to have_no_field('IPs autorisées')
      expect(page).to have_link('support@entreprise.api.gouv.fr')
    end
  end

  describe 'update' do
    before do
      visit editor_settings_path
    end

    it 'persists profile changes' do
      fill_in 'Nom', with: 'Nouveau nom éditeur'
      select 'On-premise', from: 'Type de déploiement'
      click_button 'Enregistrer les modifications'

      expect(page).to have_current_path(editor_settings_path)
      expect(page).to have_text('Paramètres mis à jour')
      expect(editor.reload.name).to eq('Nouveau nom éditeur')
      expect(editor.deployment_type).to eq('on_premise')
    end

    it 'rejects an invalid SIRET' do
      fill_in 'SIRET', with: '123'
      click_button 'Enregistrer les modifications'

      expect(editor.reload.siret).not_to eq('123')
      expect(page).to have_css('.fr-input-group--error')
    end

    it 'does not let the editor tamper with its allowed IPs' do
      expect {
        page.driver.submit :patch, editor_settings_path, editor: { name: 'Tampering', allowed_ips: '9.9.9.9' }
      }.not_to(change { editor.reload.allowed_ips })

      expect(editor.name).to eq('Tampering')
    end
  end

  context 'when the user is not an editor' do
    let(:user) { create(:user) }

    it 'redirects to root' do
      visit editor_settings_path

      expect(page).to have_current_path(root_path, ignore_query: true)
    end
  end
end
