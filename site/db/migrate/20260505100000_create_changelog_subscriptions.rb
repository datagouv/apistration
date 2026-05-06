class CreateChangelogSubscriptions < ActiveRecord::Migration[8.0]
  def change
    create_table :changelog_subscriptions, id: :uuid do |t|
      t.uuid :user_id, null: false
      t.string :scope, null: false
      t.string :unsubscribe_token, null: false
      t.datetime :disabled_at
      t.timestamps
    end

    add_index :changelog_subscriptions, %i[user_id scope],
      unique: true,
      where: 'disabled_at IS NULL',
      name: 'index_changelog_subscriptions_on_user_id_and_scope_active'
    add_index :changelog_subscriptions, :unsubscribe_token, unique: true
    add_foreign_key :changelog_subscriptions, :users, validate: false
  end
end
