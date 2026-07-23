class AddThrottleOverridesToAuthorizationRequestSecuritySettings < ActiveRecord::Migration[8.1]
  def change
    add_column :authorization_request_security_settings, :throttle_overrides, :jsonb, null: false, default: {}
  end
end
