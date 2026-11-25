class RenameEditorTokensEnabledToEditorTokensReadyOnEditors < ActiveRecord::Migration[8.1]
  def change
    safety_assured do
      rename_column :editors, :editor_tokens_enabled, :editor_tokens_ready
    end
  end
end
