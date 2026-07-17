class AddAllowedIpsToEditorTokens < ActiveRecord::Migration[8.1]
  def change
    add_column :editor_tokens, :allowed_ips, :cidr, array: true, null: false, default: []
  end
end
