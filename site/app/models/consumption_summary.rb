class ConsumptionSummary < ApplicationRecord
  self.table_name = "admin_apientreprise_#{Rails.env}_access_logs_consumption_summary"
  self.primary_key = nil

  def readonly? = true
end
