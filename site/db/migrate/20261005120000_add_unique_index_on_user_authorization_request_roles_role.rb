class AddUniqueIndexOnUserAuthorizationRequestRolesRole < ActiveRecord::Migration[8.1]
  disable_ddl_transaction!

  def change
    add_index :user_authorization_request_roles, %i[authorization_request_id role], unique: true, name: :index_user_authorization_request_roles_on_ar_id_and_role, algorithm: :concurrently
  end
end
