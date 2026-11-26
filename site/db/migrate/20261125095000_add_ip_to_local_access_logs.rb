class AddIpToLocalAccessLogs < ActiveRecord::Migration[8.1]
  def change
    return unless Rails.env.local?

    add_column :access_logs, :ip, :string
  end
end
