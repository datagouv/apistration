class CreateEditorDelegationRequests < ActiveRecord::Migration[8.1]
  def change
    create_table :editor_delegation_requests, id: :uuid do |t|
      t.references :editor_use_case, type: :uuid, null: false, foreign_key: true, index: false
      t.string :siret, null: false
      t.string :contact_email
      t.references :authorization_request, type: :uuid, foreign_key: true, index: { unique: true }
      t.jsonb :data, null: false, default: {}
      t.datetime :submitted_at
      t.references :submitted_by_user, type: :uuid, foreign_key: { to_table: :users }
      t.timestamps
    end

    add_index :editor_delegation_requests, %i[editor_use_case_id siret], unique: true
    add_index :editor_delegation_requests, :contact_email
  end
end
