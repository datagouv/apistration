class AddCreatedViaToEditorDelegations < ActiveRecord::Migration[8.1]
  def change
    add_column :editor_delegations, :created_via, :string, null: false, default: 'manual'
  end
end
