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

    import(siret, row['contact_email'].presence&.strip)
  end

  def import(siret, contact_email)
    existing = editor_use_case.editor_delegation_requests.find_by(siret:)
    return context.already_imported << existing if existing

    create(siret, contact_email)
  end

  def create(siret, contact_email)
    creation = EditorDelegationRequest::Create.call(editor_use_case:, datapass_data:, siret:, contact_email:)
    return context.failures << [siret, creation.message] if creation.failure?

    context.created << creation.editor_delegation_request
  end

  def normalize_siret(siret)
    siret.to_s.gsub(/\s/, '')
  end

  def imported_sirets
    @imported_sirets ||= Set.new
  end

  def datapass_data
    @datapass_data ||= editor_use_case.datapass_data
  end

  def editor_use_case
    context.editor_use_case
  end
end
