class AccessLogPingView < ApplicationRecord
  self.table_name = 'admin_apientreprise_production_access_logs_last_10_minutes'

  def self.refresh!
    ActiveRecord::Base.connection.execute("REFRESH MATERIALIZED VIEW #{table_name}")
  end
end
