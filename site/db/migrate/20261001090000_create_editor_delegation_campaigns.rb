class CreateEditorDelegationCampaigns < ActiveRecord::Migration[8.1]
  def change
    create_table :editor_delegation_campaigns, id: :uuid do |t|
      t.references :editor, type: :uuid, null: false, foreign_key: true, index: false
      t.string :datapass_form_uid, null: false
      t.jsonb :data, null: false, default: {}
      t.timestamps
    end

    add_index :editor_delegation_campaigns, %i[editor_id datapass_form_uid], unique: true
  end
end
