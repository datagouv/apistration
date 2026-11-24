class CreateDatapassForms < ActiveRecord::Migration[8.1]
  def change
    create_table :datapass_forms, id: :uuid do |t|
      t.string :uid, null: false, index: { unique: true }
      t.string :api, null: false
      t.string :use_case
      t.string :name
      t.text :description
      t.string :scopes, array: true, default: [], null: false
      t.jsonb :data, default: {}, null: false
      t.datetime :synced_at, null: false
      t.timestamps

      t.index %i[api use_case]
    end
  end
end
