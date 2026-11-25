require Rails.root.join('db/migrate/20261125092100_backfill_editor_use_cases_from_form_uids').to_s

RSpec.describe BackfillEditorUseCasesFromFormUids do
  subject(:backfill) { ActiveRecord::Migration.suppress_messages { described_class.new.up } }

  let(:editor) { create(:editor, name: 'Abelium', apis: %w[particulier]) }

  before do
    Editor.where(id: editor.id).update_all(
      "form_uids = ARRAY['api-particulier-abelium', 'api-particulier-abelium-petite-enfance', 'api-particulier-unknown']::varchar[], " \
      "setup_instructions = 'Menu Paramètres > API'"
    )
  end

  it 'keeps every DataPass form of the editor, the delegation link' do
    backfill

    expect(editor.reload.form_uids).to eq(%w[api-particulier-abelium api-particulier-abelium-petite-enfance api-particulier-unknown])
  end

  it 'gives each known form its DataPass use case, and leaves the unknown ones to complete' do
    backfill

    expect(editor.use_cases.pluck(:form_uid, :use_case)).to contain_exactly(
      %w[api-particulier-abelium tarification_municipale_enfance],
      %w[api-particulier-abelium-petite-enfance tarification_eaje],
      ['api-particulier-unknown', nil]
    )
  end

  it 'carries the editor name as software and its token setup instructions to each use case' do
    backfill

    expect(editor.use_cases.pluck(:software, :setup_instructions, :integration_status).uniq).to eq([['Abelium', 'Menu Paramètres > API', 'production']])
  end
end
