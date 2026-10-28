class AddNameToTokens < ActiveRecord::Migration[8.1]
  def change
    add_column :tokens, :name, :string, null: false, default: 'Jeton principal'
  end
end
