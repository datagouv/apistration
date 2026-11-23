class EditorDelegationRequest::Import < ApplicationInteractor
  SIRET_FORMAT = /\A\d{14}\z/

  before do
    context.created = []
    context.already_imported = []
    context.invalid_sirets = []
    context.duplicates = []
    context.failures = []
  end

  def call
    context.rows.each { |row| import_row(row) }

    context.editor_delegation_requests = context.created + context.already_imported
  end

  private

  def import_row(row)
    siret = normalize_siret(row['siret'])

    return context.invalid_sirets << row['siret'] unless SIRET_FORMAT.match?(siret)
    return context.duplicates << siret unless imported_sirets.add?(siret)

    import(siret, row)
  end

  def import(siret, row)
    existing = editor_delegation_campaign.editor_delegation_requests.find_by(siret:)
    return context.already_imported << existing if existing

    create(siret, row)
  end

  def create(siret, row)
    creation = EditorDelegationRequest::Create.call(editor_delegation_campaign:, datapass_data:, siret:, contact_email: row['contact_email'], data_protection_officer: data_protection_officer(row))
    return context.failures << [siret, creation.message] if creation.failure?

    context.created << creation.editor_delegation_request
  end

  def data_protection_officer(row)
    row.slice(*EditorDelegationRequest::DATA_PROTECTION_OFFICER_ATTRIBUTES).compact_blank
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
