class RemoveTokensForeignKeyFromProlongTokenWizards < ActiveRecord::Migration[8.1]
  def change
    remove_foreign_key :prolong_token_wizards, :tokens
  end
end
