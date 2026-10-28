class AddAllowedIpsToTokens < ActiveRecord::Migration[8.1]
  def change
    add_column :tokens, :allowed_ips, :cidr, array: true, default: [], null: false
  end
end
