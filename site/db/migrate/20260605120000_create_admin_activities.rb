class CreateAdminActivities < ActiveRecord::Migration[8.1]
  def change
    create_table :admin_activities, id: :uuid do |t|
      t.string :name, null: false
      t.string :namespace, null: false
      t.references :admin, type: :uuid, null: false,
        foreign_key: { to_table: :users, validate: false }
      t.references :entity, type: :uuid, polymorphic: true
      t.jsonb :before_attributes, default: {}, null: false
      t.jsonb :after_attributes, default: {}, null: false

      t.timestamps
    end

    add_index :admin_activities, :name
    add_index :admin_activities, :namespace
    add_index :admin_activities, :created_at
  end
end
