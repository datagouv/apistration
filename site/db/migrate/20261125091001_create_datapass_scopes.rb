class CreateDatapassScopes < ActiveRecord::Migration[8.1]
  def change
    create_table :datapass_scopes, id: :uuid do |t|
      t.string :api, null: false
      t.string :value, null: false
      t.string :name
      t.string :group
      t.boolean :deprecated, default: false, null: false
      t.datetime :synced_at, null: false
      t.timestamps

      t.index %i[api value], unique: true
    end
  end
end
