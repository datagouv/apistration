class ControllerName < ApplicationRecord
  self.table_name = "admin_apientreprise_#{Rails.env}_access_logs_controller_name"
  self.primary_key = nil

  def readonly? = true
end
