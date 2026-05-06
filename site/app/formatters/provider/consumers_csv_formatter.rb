class Provider::ConsumersCsvFormatter < CsvFormatter
  private

  def i18n_scope
    'provider.dashboard.consumers_csv'
  end

  def columns
    {
      datapass_id: ->(row) { row[:external_id] },
      intitule: ->(row) { row[:intitule] },
      email: ->(row) { row[:email] },
      siret: ->(row) { row[:siret] },
      denomination: ->(row) { row[:denomination] },
      total: ->(row) { row[:total] },
      unique: ->(row) { row[:unique] }
    }
  end
end
