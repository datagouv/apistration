RSpec.describe 'Admin: editors', app: :api_entreprise do
  let(:admin) { create(:user, :admin) }

  before do
    login_as(admin)
  end

  describe 'index' do
    let!(:editor) { create(:editor, :full) }
    let!(:editor_user) { create(:user, editor:) }

    before do
      visit admin_editors_path
    end

    it 'displays editors with their info' do
      expect(page).to have_text(editor.name)
      expect(page).to have_text(editor.siret)
    end

    it 'links to editor show page' do
      click_on editor.name
      expect(page).to have_current_path(admin_editor_path(editor))
    end

    it 'opens the annuaire-entreprises link without exposing window.opener' do
      expect(page).to have_css(
        "a[href='https://annuaire-entreprises.data.gouv.fr/etablissement/#{editor.siret}'][target='_blank'][rel='noopener noreferrer']"
      )
    end

    it 'lists the two-factor authentication status of each editor' do
      editor.update!(two_factor_status: 'in_progress', two_factor_deadline: Date.new(2027, 3, 31))
      visit admin_editors_path

      expect(page).to have_text('En cours (échéance 31/03/2027)')
    end

    it 'filters by name' do
      create(:editor, name: 'Other Corp')
      visit admin_editors_path(search: 'UMAD')

      expect(page).to have_text('UMAD Editor')
      expect(page).to have_no_text('Other Corp')
    end

    it 'filters by SIRET' do
      create(:editor, name: 'Other Corp', siret: '98765432109876')
      visit admin_editors_path(search: editor.siret)

      expect(page).to have_text('UMAD Editor')
      expect(page).to have_no_text('Other Corp')
    end
  end

  describe 'show' do
    let!(:editor) { create(:editor, :full, form_uids: %w[api-particulier-abelium]) }
    let!(:editor_user) { create(:user, editor:) }

    before do
      visit admin_editor_path(editor)
    end

    it 'displays editor details' do
      expect(page).to have_field('Nom', with: editor.name)
      expect(page).to have_field('editor_siret', with: editor.siret)
      expect(page).to have_field('editor_domain', with: editor.domain)
      expect(page).to have_field('editor_description', with: editor.description)
    end

    it 'opens no new tab exposing window.opener' do
      expect(page).not_to expose_window_opener
    end

    it 'opens the annuaire-entreprises link without exposing window.opener' do
      expect(page).to have_css(
        "a[href='https://annuaire-entreprises.data.gouv.fr/etablissement/#{editor.siret}'][target='_blank'][rel='noopener noreferrer']"
      )
    end

    it 'displays members' do
      expect(page).to have_text(editor_user.email)
    end
  end

  describe 'create' do
    it 'creates a new editor' do
      visit new_admin_editor_path

      fill_in 'editor_name', with: 'New Editor'
      fill_in 'editor_siret', with: '12345678901234'
      select 'Gère le jeton', from: 'editor_role'
      check 'editor_apis_entreprise'

      click_on "Créer l'éditeur"

      expect(page).to have_css('.fr-alert.fr-alert--success')
      expect(page).to have_field('Nom', with: 'New Editor')
      expect(page).to have_field('editor_siret', with: '12345678901234')
    end

    it 'records the creation activity with the created editor' do
      visit new_admin_editor_path

      fill_in 'editor_name', with: 'New Editor'
      fill_in 'editor_siret', with: '12345678901234'
      check 'editor_apis_particulier'

      expect { click_on "Créer l'éditeur" }.to change(AdminActivity, :count).by(1)

      expect(AdminActivity.last).to have_attributes(
        name: 'editor_created',
        admin:,
        namespace: 'entreprise',
        entity: Editor.find_by!(name: 'New Editor'),
        before_attributes: {}
      )
      expect(AdminActivity.last.after_attributes).to include(
        'name' => 'New Editor',
        'siret' => '12345678901234',
        'apis' => %w[particulier]
      )
    end

    it 'shows errors on invalid input' do
      visit new_admin_editor_path

      fill_in 'editor_siret', with: '12345678901234'
      click_on "Créer l'éditeur"

      expect(page).to have_css('.fr-alert.fr-alert--error')
      expect(page).to have_field('editor_siret', with: '12345678901234')
    end

    it 'records no activity on invalid input' do
      visit new_admin_editor_path

      expect { click_on "Créer l'éditeur" }.not_to change(AdminActivity, :count)
    end
  end

  describe 'update' do
    let(:editor) { create(:editor) }

    def within_tab(key, &)
      within("#editor-profile-#{key}-panel", &)
    end

    before { visit admin_editor_path(editor) }

    it 'updates the general information, SIRET and role included' do
      within_tab('general') do
        fill_in 'Nom', with: 'Renamed editor'
        fill_in 'editor_siret', with: '98765432109876'
        select 'Gère le jeton', from: 'editor_role'
        click_on 'Enregistrer'
      end

      expect(page).to have_css('.fr-alert.fr-alert--success')
      expect(editor.reload).to have_attributes(name: 'Renamed editor', siret: '98765432109876', role: 'manages_token')
    end

    it 'records the update activity' do
      within_tab('general') { uncheck 'editor_apis_particulier' }

      expect { within_tab('general') { click_on 'Enregistrer' } }.to change(AdminActivity, :count).by(1)

      expect(AdminActivity.last).to have_attributes(
        name: 'editor_updated',
        admin:,
        namespace: 'entreprise',
        entity: editor
      )
      expect(AdminActivity.last.before_attributes).to include('apis' => %w[entreprise particulier])
      expect(AdminActivity.last.after_attributes).to include('apis' => %w[entreprise])
    end

    it 'emits an editor config change with the settings before and after' do
      within_tab('technical') { check 'editor_copy_token' }

      expect { within_tab('technical') { click_on 'Enregistrer' } }.to emit_security_event('access.editor_config.changed').with(
        actor: { email: admin.email, role: 'admin' },
        target: { type: 'editor', id: editor.id },
        details: {
          changed_settings: %w[copy_jwt],
          before: { 'copy_jwt' => false },
          after: { 'copy_jwt' => true }
        }
      )
    end

    it 'emits no editor config change when only the description changes' do
      within_tab('general') { fill_in 'editor_description', with: 'Une autre description' }

      expect { within_tab('general') { click_on 'Enregistrer' } }.not_to emit_security_event('access.editor_config.changed')
    end

    it 'allows toggling editor_tokens_enabled' do
      within_tab('technical') do
        check 'editor_editor_tokens_enabled'
        click_on 'Enregistrer'
      end

      expect(editor.reload.editor_tokens_enabled).to be true
      expect(page).to have_css('.fr-alert.fr-alert--success')
    end

    it 'refuses allowed IPs the editor tokens could never accept' do
      within_tab('security') do
        fill_in 'editor_allowed_ips', with: '192.168.1.1'
        click_on 'Enregistrer'
      end

      expect(editor.reload.allowed_ips).to be_empty
      expect(page).to have_text('plage privée ou réservée')
    end

    it 'accepts public allowed IPs' do
      within_tab('security') do
        fill_in 'editor_allowed_ips', with: '203.0.113.0/24, 198.51.100.5'
        click_on 'Enregistrer'
      end

      expect(editor.reload.allowed_ips).to eq(['203.0.113.0/24', '198.51.100.5'])
    end

    it 'comes back to the tab of the saved form' do
      within_tab('security') do
        select 'SaaS', from: 'editor_deployment_type'
        click_on 'Enregistrer'
      end

      expect(page).to have_current_path(admin_editor_path(editor, onglet: 'security'))
      expect(page).to have_css('#editor-profile-security[aria-selected="true"]')
      expect(editor.reload.deployment_type).to eq('saas')
    end
  end

  describe 'observed IPs hint' do
    let(:editor) { create(:editor, form_uids: %w[api-entreprise-umad]) }
    let(:token) { create(:token, authorization_request: create(:authorization_request, demarche: 'api-entreprise-umad')) }

    before do
      %w[203.0.113.1 203.0.113.2 203.0.113.2 203.0.113.3].each { |ip| create(:access_log, token:, ip:, timestamp: 1.day.ago) }
      create(:access_log, token:, ip: '198.51.100.9', timestamp: 8.days.ago)
      create(:access_log, token: create(:token), ip: '198.51.100.10', timestamp: 1.day.ago)
    end

    it 'counts the distinct IPs calling with the habilitations of the editor over the last 7 days' do
      visit admin_editor_path(editor, onglet: 'technical')

      expect(page).to have_text('3 adresses IP distinctes sur 7 jours')
    end

    it 'counts the IPs calling with the editor token too' do
      editor_token = create(:editor_token, editor:)
      create(:access_log, token: nil, token_id: editor_token.id, ip: '192.0.2.7', timestamp: 1.day.ago)

      visit admin_editor_path(editor, onglet: 'technical')

      expect(page).to have_text('4 adresses IP distinctes sur 7 jours')
    end
  end

  describe 'contacts' do
    let!(:editor) { create(:editor) }

    before { visit admin_editor_path(editor, onglet: 'contacts') }

    it 'adds a contact and records it in the activity log' do
      within('#editor-profile-contacts-panel') do
        select 'Sécurité', from: 'Rôle'
        fill_in 'Email', with: 'rssi@editor.com'
      end

      expect { click_on 'Ajouter le contact' }.to change(AdminActivity, :count).by(1)

      expect(editor.contacts.pluck(:role, :email)).to eq([%w[security rssi@editor.com]])
      expect(AdminActivity.last).to have_attributes(name: 'editor_contact_added', entity: editor, before_attributes: {})
      expect(AdminActivity.last.after_attributes).to include('role' => 'security', 'email' => 'rssi@editor.com')
    end

    it 'removes a contact and records it in the activity log' do
      create(:editor_contact, editor:, email: 'old@editor.com')
      visit admin_editor_path(editor, onglet: 'contacts')

      expect { within('#editor-profile-contacts-panel table') { click_on 'Retirer' } }.to change(AdminActivity, :count).by(1)

      expect(editor.contacts.reload).to be_empty
      expect(AdminActivity.last).to have_attributes(name: 'editor_contact_removed', entity: editor, after_attributes: {})
      expect(AdminActivity.last.before_attributes).to include('email' => 'old@editor.com')
    end

    it 'shows the removed contact in the activity log' do
      create(:editor_contact, editor:, email: 'old@editor.com')
      visit admin_editor_path(editor, onglet: 'contacts')
      within('#editor-profile-contacts-panel table') { click_on 'Retirer' }

      visit admin_admin_activities_path

      expect(page).to have_text('email : old@editor.com → ∅')
    end

    it 'shows why a contact cannot be added' do
      click_on 'Ajouter le contact'

      expect(page).to have_css('.fr-alert.fr-alert--error', text: 'Renseignez un email ou un téléphone')
    end
  end

  describe 'members' do
    let!(:editor) { create(:editor) }
    let!(:user_to_add) { create(:user, email: 'newmember@test.com') }

    it 'adds a member to the editor' do
      visit admin_editor_path(editor)

      fill_in 'email', with: 'newmember@test.com'
      click_on 'Ajouter'

      expect(page).to have_css('.fr-alert.fr-alert--success')
      expect(page).to have_text('newmember@test.com')
    end

    it 'records the member addition activity' do
      visit admin_editor_path(editor)

      fill_in 'email', with: 'newmember@test.com'

      expect { click_on 'Ajouter' }.to change(AdminActivity, :count).by(1)

      expect(AdminActivity.last).to have_attributes(
        name: 'editor_member_added',
        admin:,
        namespace: 'entreprise',
        entity: user_to_add
      )
    end

    it 'removes a member from the editor' do
      user_to_add.update!(editor:)
      visit admin_editor_path(editor)

      click_on 'Retirer'

      expect(page).to have_css('.fr-alert.fr-alert--success')
      expect(user_to_add.reload.editor_id).to be_nil
    end

    it 'records the member removal activity' do
      user_to_add.update!(editor:)
      visit admin_editor_path(editor)

      expect { click_on 'Retirer' }.to change(AdminActivity, :count).by(1)

      expect(AdminActivity.last).to have_attributes(
        name: 'editor_member_removed',
        admin:,
        namespace: 'entreprise',
        entity: user_to_add
      )
    end

    it 'shows error for unknown email' do
      visit admin_editor_path(editor)

      fill_in 'email', with: 'unknown@test.com'
      click_on 'Ajouter'

      expect(page).to have_css('.fr-alert.fr-alert--error')
    end
  end

  describe 'generating an editor token' do
    let(:editor) { create(:editor) }

    it 'records the activity' do
      visit admin_editor_path(editor)

      expect { click_on 'Générer un nouveau jeton éditeur' }.to change(AdminActivity, :count).by(1)

      expect(AdminActivity.last).to have_attributes(
        name: 'editor_token_created',
        admin:,
        namespace: 'entreprise',
        entity: editor.tokens.last
      )
      expect(AdminActivity.last.after_attributes).to eq('exp' => editor.tokens.last.exp)
    end

    it 'emits an editor token creation by the admin' do
      visit admin_editor_path(editor)

      expect { click_on 'Générer un nouveau jeton éditeur' }.to emit_security_event('token.editor_token.created').with(
        actor: { email: admin.email, role: 'admin' },
        target: { type: 'editor_token', id: kind_of(String) },
        details: { source: 'admin', editor_id: editor.id }
      )
    end
  end
end
