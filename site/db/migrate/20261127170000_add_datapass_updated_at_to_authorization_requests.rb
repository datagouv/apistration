class AddDatapassUpdatedAtToAuthorizationRequests < ActiveRecord::Migration[8.1]
  def change
    add_column :authorization_requests, :datapass_updated_at, :datetime, precision: 6
  end
end
