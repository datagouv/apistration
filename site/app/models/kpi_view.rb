class KpiView < ApplicationRecord
  self.abstract_class = true
  self.primary_key = nil

  def readonly? = true

  class Kpi1 < KpiView
    self.table_name = "admin_apientreprise_#{Rails.env}_access_logs_kpi1"
  end

  class Kpi2 < KpiView
    self.table_name = "admin_apientreprise_#{Rails.env}_access_logs_kpi2"
  end

  class Kpi3 < KpiView
    self.table_name = "admin_apientreprise_#{Rails.env}_access_logs_kpi3"
  end
end
