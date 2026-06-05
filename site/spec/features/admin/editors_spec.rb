RSpec.describe 'Admin: editors', app: :api_entreprise do
  let(:admin) { create(:user, :admin) }

  before do
    login_as(admin)
  end

  describe 'index' do
    let!(:editor) { create(:editor) }
    let!(:editor_user) { create(:user, editor:) }

    before do
      visit admin_editors_path
    end

    it 'displays editors' do
      expect(page).to have_css('.editor', count: 1)

      expect(page).to have_text(editor.name)
      expect(page).to have_text(editor_user.email)
      expect(page).to have_text(editor.form_uids.first)
    end
  end

  describe 'update' do
    subject do
      visit edit_admin_editor_path(editor)

      fill_in 'editor_form_uids', with: new_forms

      click_on 'Sauvegarder'
    end

    let(:editor) { create(:editor) }
    let(:new_forms) { 'new_form1, new_form2' }

    it 'works and displays flash message' do
      expect { subject }.to change { editor.reload.form_uids }.to(new_forms.split(', '))

      expect(page).to have_css('.fr-alert.fr-alert--success')
    end

    it 'records the update activity' do
      expect { subject }.to change(AdminActivity, :count).by(1)

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
