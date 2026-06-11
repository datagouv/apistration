class AddFieldsToEditors < ActiveRecord::Migration[8.1]
  def change
    add_column :editors, :siret, :string
    add_column :editors, :role, :string
    add_column :editors, :contact_email, :string
    add_column :editors, :contact_phone, :string
    add_column :editors, :deployment_type, :string
    add_column :editors, :setup_instructions, :text
    add_column :editors, :domain, :string
    add_column :editors, :languages, :string
    add_column :editors, :description, :text
    add_column :editors, :allowed_ips, :jsonb, default: [], null: false
  end
end
