class CreateEditorContacts < ActiveRecord::Migration[8.1]
  def change
    create_table :editor_contacts, id: :uuid do |t|
      t.references :editor, type: :uuid, null: false, foreign_key: true
      t.string :role, null: false
      t.string :full_name
      t.string :email
      t.string :phone
      t.timestamps
    end
  end
end
