class ConsumptionSummary < ApplicationRecord
  self.table_name = 'consumption_summary'
  self.primary_key = nil

  def readonly? = true
end
