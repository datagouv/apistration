class EditorDelegationRequest::Import < ApplicationInteractor
  SIRET_FORMAT = /\A\d{14}\z/
  LA_POSTE_SIREN = '356000000'.freeze
  KNOWN_COLUMNS = (%w[siret contact_email] + EditorDelegationRequest::IMPORTED_DATA_ATTRIBUTES).freeze

  before do
    context.created = []
    context.already_imported = []
    context.invalid_sirets = []
    context.duplicates = []
    context.failures = []
  end

  def call
    reject_unknown_columns

    context.rows.each { |row| import_row(row) }

    context.editor_delegation_requests = context.created + context.already_imported
  end

  private

  def import_row(row)
    siret = normalize_siret(row['siret'])

    return context.invalid_sirets << row['siret'] unless valid_siret?(siret)
    return context.duplicates << siret unless imported_sirets.add?(siret)

    import(siret, row)
  end

  def valid_siret?(siret)
    SIRET_FORMAT.match?(siret) && (luhn_valid?(siret) || la_poste?(siret))
  end

  def luhn_valid?(siret)
    (siret.chars.reverse.each_with_index.sum { |digit, index| index.odd? ? (digit.to_i * 2).digits.sum : digit.to_i } % 10).zero?
  end

  def la_poste?(siret)
    siret.start_with?(LA_POSTE_SIREN) && (siret.chars.sum(&:to_i) % 5).zero?
  end

  def import(siret, row)
    existing = editor_delegation_campaign.editor_delegation_requests.find_by(siret:)
    return context.already_imported << existing if existing

    create(siret, row)
  end

  def create(siret, row)
    creation = EditorDelegationRequest::Create.call(editor_delegation_campaign:, datapass_data:, siret:, contact_email: row['contact_email'], data: imported_data(row))
    return context.failures << [siret, creation.message] if creation.failure?

    context.created << creation.editor_delegation_request
  end

  def imported_data(row)
    row.slice(*EditorDelegationRequest::IMPORTED_DATA_ATTRIBUTES).compact_blank
  end

  def reject_unknown_columns
    return if unknown_columns.empty?

    context.fail!(message: "Colonnes inconnues : #{unknown_columns.map { |column| column || '(sans en-tête)' }.join(', ')}")
  end

  def unknown_columns
    @unknown_columns ||= context.rows.flat_map { |row| row.compact_blank.keys }.uniq - KNOWN_COLUMNS
  end

  def normalize_siret(siret)
    siret.to_s.gsub(/\s/, '')
  end

  def imported_sirets
    @imported_sirets ||= Set.new
  end

  def datapass_data
    @datapass_data ||= editor_delegation_campaign.datapass_data
  end

  def editor_delegation_campaign
    context.editor_delegation_campaign
  end
end
