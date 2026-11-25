class CreateEditorUseCases < ActiveRecord::Migration[8.1]
  def change
    create_table :editor_use_cases, id: :uuid do |t|
      t.references :editor, type: :uuid, null: false, foreign_key: true
      t.string :use_case
      t.string :software
      t.text :software_description
      t.string :software_url
      t.string :scopes, array: true, default: [], null: false
      t.integer :data_retention_months
      t.text :data_recipients
      t.text :setup_instructions
      t.string :form_uid, index: { unique: true, where: 'form_uid IS NOT NULL' }
      t.boolean :security_accreditation
      t.date :security_accreditation_begin_date
      t.date :security_accreditation_end_date
      t.string :mon_service_securise_url
      t.timestamps
    end
  end
end
