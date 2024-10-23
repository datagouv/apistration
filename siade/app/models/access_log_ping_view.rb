class AccessLogPingView < ApplicationRecord
  self.table_name = "admin_apientreprise_#{Rails.env}_access_logs_last_10_minutes"

  def self.refresh!
    ActiveRecord::Base.connection.execute("REFRESH MATERIALIZED VIEW #{table_name}")
  end
end
