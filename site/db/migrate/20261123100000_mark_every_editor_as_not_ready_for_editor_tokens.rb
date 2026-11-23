class MarkEveryEditorAsNotReadyForEditorTokens < ActiveRecord::Migration[8.1]
  def up
    safety_assured do
      execute('UPDATE editors SET editor_tokens_enabled = false WHERE editor_tokens_enabled')
    end
  end

  def down; end
end
