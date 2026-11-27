class EditorDelegationBatch::Signature
  include ActiveModel::Model
  include ActiveModel::Attributes

  attribute :terms_of_service_accepted, :boolean
  attribute :data_protection_officer_informed, :boolean
  attribute :included_ids

  attr_reader :batch, :user

  validates :terms_of_service_accepted, :data_protection_officer_informed, acceptance: { accept: true, allow_nil: false }
  validate :some_establishment_included
  validate :data_protection_officers_complete

  def initialize(batch:, user:, **attributes)
    @batch = batch
    @user = user
    super(**attributes)
  end

  def included_ids=(ids)
    super(ids&.compact_blank)
  end

  def included?(request)
    included_ids.nil? || included_ids.include?(request.id)
  end

  def included_requests
    batch.pending_requests.select { |request| included?(request) }
  end

  def save
    return false if invalid?

    EditorDelegationRequest.transaction do
      submit_included_requests(EditorDelegationRequest.where(id: batch.pending_requests.map(&:id), submitted_at: nil).lock.ids)
    end
  end

  def submitted_at
    @submitted_at ||= Time.zone.now
  end

  private

  def submit_included_requests(still_pending_ids)
    included_requests.select { |request| still_pending_ids.include?(request.id) }.each { |request| submit(request) }
  end

  def submit(request)
    request.assign_attributes(submitted_at:, submitted_by_user_id: user.id, terms_of_service_accepted:, data_protection_officer_informed:, datapass_error: nil)
    request.save!(context: :submission)
    SubmitEditorDelegationRequestToDatapassJob.perform_later(request.id, consents)
  end

  def consents
    { terms_of_service_accepted:, data_protection_officer_informed: }
  end

  def some_establishment_included
    errors.add(:included_ids, :blank) if included_requests.empty?
  end

  def data_protection_officers_complete
    missing = batch.organizations_without_data_protection_officer.select { |organization| organization.requests.any? { |request| included?(request) } }

    errors.add(:base, "Renseignez le délégué à la protection des données de #{missing.map(&:name).to_sentence} avant de soumettre.") if missing.any?
  end
end
