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

  describe 'security and hosting' do
    before { visit editor_settings_path(onglet: 'security') }

    it 'declares a two-factor authentication in progress with its deadline and methods' do
      within_tab('security') do
        choose 'En cours'
        fill_in 'Échéance si en cours', with: '2027-03-31'
        check 'Application TOTP'
        check 'ProConnect'
        fill_in 'Hébergeur', with: 'OVHcloud'
        fill_in "Pays d'hébergement", with: 'France'
        choose 'editor_has_designated_rssi_true'
        click_button 'Enregistrer'
      end

      expect(editor.reload).to have_attributes(
        two_factor_status: 'in_progress',
        two_factor_deadline: Date.new(2027, 3, 31),
        two_factor_methods: %w[totp proconnect],
        hosting_provider: 'OVHcloud',
        hosting_country: 'France',
        has_designated_rssi: true
      )
    end

    it 'asks for the deadline of a two-factor authentication in progress' do
      within_tab('security') do
        choose 'En cours'
        click_button 'Enregistrer'
      end

      expect(editor.reload.two_factor_status).to be_nil
      expect(page).to have_css('#editor-profile-security-panel .fr-input-group--error')
    end
  end

  describe 'contacts' do
    before { visit editor_settings_path(onglet: 'contacts') }

    it 'lists the former contact email and phone of the editor as its technical contact' do
      require Rails.root.join('db/migrate/20261125093100_move_editor_contact_to_technical_contacts').to_s
      editor.contacts.delete_all
      Editor.where(id: editor.id).update_all("contact_email = 'legacy@editor.com', contact_phone = '0611111111'")
      ActiveRecord::Migration.suppress_messages { MoveEditorContactToTechnicalContacts.new.up }

      visit editor_settings_path(onglet: 'contacts')

      within_tab('contacts') do
        expect(page).to have_css('tr', text: /Technique.*legacy@editor\.com.*0611111111/)
      end
    end

    it 'adds several contacts for the same role' do
      within_tab('contacts') do
        select 'Délégué à la protection des données (DPO)', from: 'Rôle'
        fill_in 'Nom', with: 'Alice DPO'
        fill_in 'Email', with: 'dpo@editor.com'
        click_button 'Ajouter le contact'
      end
      within_tab('contacts') do
        select 'Délégué à la protection des données (DPO)', from: 'Rôle'
        fill_in 'Email', with: 'dpo-suppleant@editor.com'
        click_button 'Ajouter le contact'
      end

      expect(editor.contacts.where(role: 'dpo').pluck(:email)).to contain_exactly('dpo@editor.com', 'dpo-suppleant@editor.com')
    end

    it 'removes a contact' do
      within_tab('contacts') { click_button 'Retirer' }

      expect(editor.contacts.reload).to be_empty
    end

    it 'cannot remove the contact of another editor' do
      other_contact = create(:editor_contact, editor: create(:editor))

      page.driver.submit :delete, editor_contact_path(other_contact), {}

      expect(other_contact.reload).to be_persisted
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
