class EditorDelegationBatch::Signature
  include ActiveModel::Model
  include ActiveModel::Attributes

  attribute :terms_of_service_accepted, :boolean
  attribute :data_protection_officer_informed, :boolean
  attribute :included_ids
  attribute :data_protection_officer

  attr_reader :batch, :user

  validates :terms_of_service_accepted, :data_protection_officer_informed, acceptance: { accept: true, allow_nil: false }
  validate :some_establishment_included
  validate :data_protection_officer_filled_in
  validate :data_protection_officers_complete

  def initialize(batch:, user:, **attributes)
    @batch = batch
    @user = user
    super(**attributes)
  end

  def included_ids=(ids)
    super(ids&.compact_blank)
  end

  def data_protection_officer_form
    @data_protection_officer_form ||= batch.organizations.first.lead_request.dup.tap do |form|
      form.assign_attributes(data_protection_officer.to_h)
    end
  end

  def included?(request)
    included_ids.nil? || included_ids.include?(request.id)
  end

  def included_requests
    batch.pending_requests.select { |request| included?(request) }
  end

  def save
    apply_shared_data_protection_officer
    return false if invalid?

    EditorDelegationRequest.transaction do
      still_pending_ids = EditorDelegationRequest.where(id: batch.pending_requests.map(&:id), submitted_at: nil).lock.ids

      save_data_protection_officers(still_pending_ids)
      submit_included_requests(still_pending_ids)
    end
  end

  def submitted_at
    @submitted_at ||= Time.zone.now
  end

  private

  def apply_shared_data_protection_officer
    return unless batch.data_protection_officer_shared_form? && data_protection_officer

    batch.pending_requests.each { |request| request.assign_attributes(data_protection_officer.to_h) }
  end

  def save_data_protection_officers(still_pending_ids)
    batch.pending_requests
      .select { |request| still_pending_ids.include?(request.id) && request.changed? }
      .each { |request| request.save!(context: :data_protection_officer) }
  end

  def submit_included_requests(still_pending_ids)
    included_requests.select { |request| still_pending_ids.include?(request.id) }.each do |request|
      request.assign_attributes(submitted_at:, submitted_by_user_id: user.id, terms_of_service_accepted:, data_protection_officer_informed:)
      request.save!(context: :submission)
    end
  end

  def some_establishment_included
    errors.add(:included_ids, :blank) if included_requests.empty?
  end

  def data_protection_officer_filled_in
    return unless batch.data_protection_officer_shared_form? && data_protection_officer

    data_protection_officer_form.validate(:data_protection_officer)
    invalid_attributes = data_protection_officer_form.errors.attribute_names.map(&:to_s) & EditorDelegationRequest::DATA_PROTECTION_OFFICER_ATTRIBUTES

    errors.add(:data_protection_officer, :invalid) if invalid_attributes.any?
  end

  def data_protection_officers_complete
    return if batch.data_protection_officer_shared_form? && data_protection_officer

    missing = batch.organizations_without_data_protection_officer.select { |organization| organization.requests.any? { |request| included?(request) } }

    errors.add(:base, "Renseignez le délégué à la protection des données de #{missing.map(&:name).to_sentence} avant de signer.") if missing.any?
  end
end
