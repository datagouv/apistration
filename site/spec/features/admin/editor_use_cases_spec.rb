RSpec.describe 'Admin: editor use cases', app: :api_particulier do
  let(:admin) { create(:user, :admin) }
  let(:editor) { create(:editor, name: 'UMAD & Co', apis: %w[particulier]) }

  before do
    stub_datapass_referential
    login_as(admin)
  end

  it 'attaches a DataPass form to a new use case, records it and warns the CISRT' do
    visit new_admin_editor_use_case_path(editor, use_case: 'tarification_municipale_enfance')
    fill_in 'Nom du logiciel', with: 'Logiciel enfance'
    fill_in 'Formulaire DataPass', with: 'api-particulier-umad'

    expect { click_on 'Enregistrer' }.to emit_security_event('access.editor_config.changed').with(
      actor: { email: admin.email, role: 'admin' },
      target: { type: 'editor', id: editor.id },
      details: { changed_settings: %w[form_uids], before: { 'form_uids' => [] }, after: { 'form_uids' => %w[api-particulier-umad] } }
    )

    expect(Editor.for_demarche('api-particulier-umad')).to eq([editor])
    expect(AdminActivity.last).to have_attributes(name: 'editor_use_case_created', entity: editor)
    expect(AdminActivity.last.after_attributes).to include('form_uid' => 'api-particulier-umad', 'software' => 'Logiciel enfance')
  end

  context 'with a use case attached to a DataPass form' do
    let!(:use_case) { create(:editor_use_case, editor:, form_uid: 'api-particulier-umad') }

    it 'warns the CISRT when the form changes' do
      visit edit_admin_editor_use_case_path(editor, use_case)
      expect(page).to have_title('Logiciel enfance – UMAD & Co – Modifier une démarche')
      expect(page).to have_css('#editor-use-case-context', text: 'Éditeur : UMAD & Co')
      expect(page).to have_css('#editor-use-case-context', text: 'Logiciel : Logiciel enfance')
      expect(page).to have_link('Retour aux démarches de UMAD & Co', href: admin_editor_path(editor, onglet: 'use_cases'))
      fill_in 'Formulaire DataPass', with: 'api-particulier-umad-v2'

      expect { click_on 'Enregistrer' }.to emit_security_event('access.editor_config.changed').with(
        actor: { email: admin.email, role: 'admin' },
        target: { type: 'editor', id: editor.id },
        details: { changed_settings: %w[form_uids], before: { 'form_uids' => %w[api-particulier-umad] }, after: { 'form_uids' => %w[api-particulier-umad-v2] } }
      )
      expect(AdminActivity.last.before_attributes).to include('form_uid' => 'api-particulier-umad')
    end

    it 'comes back to the use cases with an error when the use case was removed meanwhile' do
      visit edit_admin_editor_use_case_path(editor, use_case)
      use_case.destroy!

      click_on 'Enregistrer'

      expect(page).to have_current_path(admin_editor_path(editor, onglet: 'use_cases'))
      expect(page).to have_css('.fr-alert.fr-alert--error', text: 'Élément introuvable')
    end

    it 'does not warn the CISRT when the form stays the same' do
      visit edit_admin_editor_use_case_path(editor, use_case)
      fill_in 'Nom du logiciel', with: 'Nouveau nom'

      expect { click_on 'Enregistrer' }.not_to emit_security_event('access.editor_config.changed')
      expect(use_case.reload.software).to eq('Nouveau nom')
    end

    it 'warns the CISRT when the use case and its form are removed' do
      visit admin_editor_path(editor, onglet: 'use_cases')

      expect { within('#editor-profile-use_cases-panel') { click_on 'Retirer' } }.to emit_security_event('access.editor_config.changed').with(
        actor: { email: admin.email, role: 'admin' },
        target: { type: 'editor', id: editor.id },
        details: { changed_settings: %w[form_uids], before: { 'form_uids' => %w[api-particulier-umad] }, after: { 'form_uids' => [] } }
      )
      expect(AdminActivity.last).to have_attributes(name: 'editor_use_case_removed', after_attributes: {})
    end
  end
end
