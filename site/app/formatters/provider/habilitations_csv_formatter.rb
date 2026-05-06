class Provider::HabilitationsCsvFormatter < CsvFormatter
  COLUMN_KEYS = {
    datapass_id: :external_id,
    intitule: :intitule,
    siret: :siret,
    denomination: :denomination,
    email: :email
  }.freeze

  private

  def i18n_scope
    'provider.dashboard.habilitations_csv'
  end

  def columns
    COLUMN_KEYS.transform_values { |key| ->(row) { row[key] } }.merge(
      status: ->(row) { I18n.t("provider.dashboard.habilitations_table.statuses.#{row[:status]}", default: row[:status]) },
      scopes: ->(row) { Array(row[:scopes]).join('|') }
    )
  end
end
