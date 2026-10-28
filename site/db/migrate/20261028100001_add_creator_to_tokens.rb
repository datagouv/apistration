class AddCreatorToTokens < ActiveRecord::Migration[8.1]
  def change
    add_column :tokens, :creator_id, :uuid
  end
end
