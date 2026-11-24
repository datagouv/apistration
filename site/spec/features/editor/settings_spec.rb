RSpec.describe 'Editor: settings', app: :api_entreprise do
  let(:editor) { create(:editor, :full) }
  let(:user) { create(:user, editor:) }

  def within_tab(key, &)
    within("#editor-profile-#{key}-panel", &)
  end

  before do
    login_as(user)
  end

  describe 'show' do
    before do
      visit editor_settings_path
    end

    it 'prefills the editable profile fields' do
      expect(page).to have_field('Nom', with: editor.name)
      expect(page).to have_field('Site internet', with: editor.domain)
      expect(page).to have_field('Instructions de configuration du jeton', with: editor.setup_instructions)
    end

    it 'shows the fields only an admin can change without letting the editor edit them' do
      within_tab('general') { expect(page).to have_text(editor.siret) }
      expect(page).to have_no_field('editor_siret')
      expect(page).to have_no_field('editor_role')
      expect(page).to have_no_field('editor_editor_tokens_enabled')
    end

    it 'displays the allowed IPs read-only, without an editable field' do
      editor.allowed_ips.each { |ip| expect(page).to have_text(ip) }
      expect(page).to have_no_field('editor_allowed_ips')
      expect(page).to have_link('support@entreprise.api.gouv.fr')
    end

    it 'displays the INSEE data known for the SIRET' do
      create(:organization, siret: editor.siret, insee_payload: {
        'etablissement' => {
          'uniteLegale' => { 'denominationUniteLegale' => 'UMAD SAS', 'activitePrincipaleUniteLegale' => '58.29C' },
          'adresseEtablissement' => { 'numeroVoieEtablissement' => '20', 'typeVoieEtablissement' => 'AVENUE', 'libelleVoieEtablissement' => 'DE SEGUR', 'codePostalEtablissement' => '75007', 'libelleCommuneEtablissement' => 'PARIS' }
        }
      })
      visit editor_settings_path

      within_tab('general') do
        expect(page).to have_text('UMAD SAS')
        expect(page).to have_text('20 AVENUE DE SEGUR, 75007 PARIS')
        expect(page).to have_text('58.29C')
      end
    end
  end

  describe 'update' do
    before do
      visit editor_settings_path
    end

    it 'persists general information changes' do
      within_tab('general') do
        fill_in 'Nom', with: 'Nouveau nom éditeur'
        click_button 'Enregistrer'
      end

      expect(page).to have_current_path(editor_settings_path(onglet: 'general'))
      expect(page).to have_text('Informations mises à jour')
      expect(editor.reload.name).to eq('Nouveau nom éditeur')
    end

    it 'lets the editor write the setup instructions of its token' do
      within_tab('technical') do
        fill_in 'Instructions de configuration du jeton', with: 'Menu Paramètres > API'
        click_button 'Enregistrer'
      end

      expect(page).to have_css('#editor-profile-technical[aria-selected="true"]')
      expect(editor.reload.setup_instructions).to eq('Menu Paramètres > API')
    end

    it 'shows the error on the tab of the invalid form' do
      within_tab('general') do
        fill_in 'Nom', with: ''
        click_button 'Enregistrer'
      end

      expect(editor.reload.name).to eq('UMAD Editor')
      expect(page).to have_css('#editor-profile-general-panel .fr-input-group--error')
    end

    it 'does not let the editor tamper with the fields only an admin can change' do
      expect {
        page.driver.submit :patch, editor_settings_path(onglet: 'general'), editor: { name: 'Tampering', siret: '98765432109876', role: 'both', apis: %w[particulier] }
      }.not_to(change { editor.reload.slice(:siret, :role, :apis) })

      expect(editor.name).to eq('Tampering')
    end

    it 'does not let the editor tamper with its allowed IPs nor its token settings' do
      expect {
        page.driver.submit :patch, editor_settings_path(onglet: 'security'), editor: { deployment_type: 'on_premise', allowed_ips: '9.9.9.9' }
        page.driver.submit :patch, editor_settings_path(onglet: 'technical'), editor: { languages: 'Go', copy_token: '1', editor_tokens_enabled: '1' }
      }.not_to(change { editor.reload.slice(:allowed_ips, :copy_token, :editor_tokens_enabled) })

      expect(editor).to have_attributes(deployment_type: 'on_premise', languages: 'Go')
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
