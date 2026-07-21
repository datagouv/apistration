class AddApisToEditors < ActiveRecord::Migration[8.1]
  def change
    add_column :editors, :apis, :string, array: true, default: [], null: false
  end
end
