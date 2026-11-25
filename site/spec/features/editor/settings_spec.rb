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
        fill_in 'Nom public de l’entreprise', with: 'Nouveau nom éditeur'
        click_button 'Enregistrer'
      end

      expect(page).to have_current_path(editor_settings_path(onglet: 'general'))
      expect(page).to have_text('Informations mises à jour')
      expect(editor.reload.name).to eq('Nouveau nom éditeur')
    end

    it 'shows the error on the tab of the invalid form' do
      within_tab('general') do
        fill_in 'Nom public de l’entreprise', with: ''
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
        page.driver.submit :patch, editor_settings_path(onglet: 'general'), editor: { description: 'Logiciel enfance', copy_token: '1', editor_tokens_enabled: '1' }
      }.not_to(change { editor.reload.slice(:allowed_ips, :copy_token, :editor_tokens_enabled) })

      expect(editor).to have_attributes(deployment_type: 'on_premise', description: 'Logiciel enfance')
    end
  end

  describe 'security and hosting' do
    before { visit editor_settings_path(onglet: 'security') }

    it 'declares a two-factor authentication in progress with its deadline and methods' do
      within_tab('security') do
        choose 'En cours'
        fill_in 'Échéance de mise en place', with: '2027-03-31'
        check 'Application TOTP'
        check 'Clé matérielle'
        fill_in 'Hébergeur', with: 'OVHcloud'
        fill_in "Pays d'hébergement", with: 'France'
        click_button 'Enregistrer'
      end

      expect(editor.reload).to have_attributes(
        two_factor_status: 'in_progress',
        two_factor_deadline: Date.new(2027, 3, 31),
        two_factor_methods: %w[totp hardware_key],
        hosting_provider: 'OVHcloud',
        hosting_country: 'France'
      )
    end

    it 'keeps the selected tab in the URL and asks the deadline only for a two-factor authentication in progress', :js do
      find_by_id('editor-profile-contacts').click
      expect(page).to have_current_path(editor_settings_path(onglet: 'contacts'))
      find_by_id('editor-profile-security').click
      expect(page).to have_current_path(editor_settings_path(onglet: 'security'))

      within_tab('security') do
        expect(page).to have_no_field('Échéance de mise en place')
        choose 'En cours', allow_label_click: true
        expect(page).to have_field('Échéance de mise en place')
        choose 'Non', allow_label_click: true
        expect(page).to have_no_field('Échéance de mise en place')
      end
    end
  end

  describe 'what is left to fill in' do
    let(:editor) { create(:editor) }

    it 'lists the missing information and links each to its tab, until it is given' do
      visit editor_settings_path

      expect(page).to have_text('Votre fiche est à compléter : 4 informations manquantes')
      expect(page).to have_link('Un contact Sécurité (RSSI)', href: editor_settings_path(onglet: 'contacts'))
      expect(page).to have_link("Au moins un cas d'usage", href: editor_settings_path(onglet: 'use_cases'))

      create(:editor_contact, editor:, role: 'technical')
      create(:editor_contact, editor:, role: 'security')
      editor.update!(two_factor_status: 'yes')
      create(:editor_use_case, editor:)
      visit editor_settings_path

      expect(page).to have_css('h1', text: 'Vos informations éditeur')
      expect(page).to have_no_text('Votre fiche est à compléter')
    end

    it 'counts the use cases still to complete, such as one backfilled without its DataPass use case' do
      create(:editor_use_case, editor:)
      create(:editor_use_case, editor:, form_uid: 'api-entreprise-unknown').update_columns(use_case: nil, scopes: [])
      visit editor_settings_path

      expect(page).to have_link("1 cas d'usage à compléter")
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
