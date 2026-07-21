class RenameDelegationsEnabledToEditorTokensEnabledOnEditors < ActiveRecord::Migration[8.0]
  def change
    safety_assured do
      rename_column :editors, :delegations_enabled, :editor_tokens_enabled
    end
  end
end
