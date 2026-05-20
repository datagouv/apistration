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

    it 'filters by name' do
      create(:editor, name: 'Other Corp')
      visit admin_editors_path(search: 'UMAD')

      expect(page).to have_text('UMAD Editor')
      expect(page).to have_no_text('Other Corp')
    end

    it 'filters by role' do
      create(:editor, name: 'No Role Editor')
      visit admin_editors_path(role: 'manages_token')

      expect(page).to have_text('UMAD Editor')
      expect(page).to have_no_text('No Role Editor')
    end
  end

  describe 'show' do
    let!(:editor) { create(:editor, :full) }
    let!(:editor_user) { create(:user, editor:) }

    before do
      visit admin_editor_path(editor)
    end

    it 'displays editor details' do
      expect(page).to have_text(editor.name)
      expect(page).to have_text(editor.siret)
      expect(page).to have_text(editor.contact_email)
      expect(page).to have_text(editor.domain)
      expect(page).to have_text(editor.description)
    end

    it 'displays members' do
      expect(page).to have_text(editor_user.email)
    end

    it 'displays form_uids as tags' do
      editor.form_uids.each do |form_uid|
        expect(page).to have_text(form_uid)
      end
    end
  end

  describe 'create' do
    it 'creates a new editor' do
      visit new_admin_editor_path

      fill_in 'editor_name', with: 'New Editor'
      fill_in 'editor_siret', with: '12345678901234'
      select 'Gère le jeton', from: 'editor_role'
      fill_in 'editor_contact_email', with: 'test@editor.com'

      click_on "Créer l'éditeur"

      expect(page).to have_css('.fr-alert.fr-alert--success')
      expect(page).to have_text('New Editor')
      expect(page).to have_text('12345678901234')
    end

    it 'shows errors on invalid input' do
      visit new_admin_editor_path

      click_on "Créer l'éditeur"

      expect(page).to have_css('.fr-alert.fr-alert--error')
    end
  end

  describe 'update' do
    let(:editor) { create(:editor) }

    it 'updates editor fields' do
      visit edit_admin_editor_path(editor)

      fill_in 'editor_form_uids', with: 'new_form1, new_form2'
      click_on 'Sauvegarder'

      expect(editor.reload.form_uids).to eq(%w[new_form1 new_form2])
      expect(page).to have_css('.fr-alert.fr-alert--success')
    end

    it 'records the update activity' do
      visit edit_admin_editor_path(editor)

      fill_in 'editor_form_uids', with: 'new_form1, new_form2'

      expect { click_on 'Sauvegarder' }.to change(AdminActivity, :count).by(1)

      expect(AdminActivity.last).to have_attributes(
        name: 'editor_updated',
        admin:,
        namespace: 'entreprise',
        entity: editor
      )
    end

    it 'allows toggling delegations_enabled' do
      visit edit_admin_editor_path(editor)

      check 'editor_delegations_enabled'
      click_on 'Sauvegarder'

      expect(editor.reload.delegations_enabled).to be true
      expect(page).to have_css('.fr-alert.fr-alert--success')
    end

    it 'updates new fields' do
      visit edit_admin_editor_path(editor)

      fill_in 'editor_siret', with: '98765432109876'
      select 'SaaS', from: 'editor_deployment_type'
      fill_in 'editor_contact_email', with: 'new@editor.com'
      click_on 'Sauvegarder'

      editor.reload
      expect(editor.siret).to eq('98765432109876')
      expect(editor.deployment_type).to eq('saas')
      expect(editor.contact_email).to eq('new@editor.com')
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

    it 'removes a member from the editor' do
      user_to_add.update!(editor:)
      visit admin_editor_path(editor)

      click_on 'Retirer'

      expect(page).to have_css('.fr-alert.fr-alert--success')
      expect(user_to_add.reload.editor_id).to be_nil
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
      visit edit_admin_editor_path(editor)

      expect { click_on 'Générer un nouveau jeton éditeur' }.to change(AdminActivity, :count).by(1)

      expect(AdminActivity.last).to have_attributes(
        name: 'editor_token_created',
        admin:,
        namespace: 'entreprise',
        entity: editor.tokens.last
      )
      expect(AdminActivity.last.after_attributes).to eq('exp' => editor.tokens.last.exp)
    end
  end
end
