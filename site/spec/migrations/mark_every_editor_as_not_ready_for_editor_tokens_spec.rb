require 'rails_helper'
require Rails.root.join('db/migrate/20261123100000_mark_every_editor_as_not_ready_for_editor_tokens')

RSpec.describe MarkEveryEditorAsNotReadyForEditorTokens do
  let!(:ready_editors) { create_list(:editor, 2, :editor_tokens_ready) }
  let!(:editor_not_ready) { create(:editor) }

  it 'leaves no editor marked ready: an admin marks each one once it uses its editor tokens' do
    ActiveRecord::Migration.suppress_messages { described_class.new.up }

    expect(Editor.where(editor_tokens_ready: true)).to be_empty
    expect(editor_not_ready.reload.editor_tokens_ready).to be(false)
  end
end
