class EditorDelegationBatch
  SMALL_SIZE = 10

  attr_reader :editor_delegation_campaign, :contact_email

  delegate :editor, to: :editor_delegation_campaign

  def self.of(editor_delegation_request)
    new(editor_delegation_request.editor_delegation_campaign, editor_delegation_request.contact_email)
  end

  def initialize(editor_delegation_campaign, contact_email)
    @editor_delegation_campaign = editor_delegation_campaign
    @contact_email = contact_email
  end

  def requests
    return EditorDelegationRequest.none if contact_email.blank?

    editor_delegation_campaign.editor_delegation_requests.where(contact_email:).order(:siret)
  end

  def pending_requests
    @pending_requests ||= requests.where(submitted_at: nil).to_a
  end

  def submitted_requests
    requests.where.not(submitted_at: nil).includes(:submitted_by_user)
  end

  def signatory?(user)
    contact_email.present? && user.present? && user.email.to_s.strip.downcase == contact_email
  end

  def organizations
    @organizations ||= pending_requests
      .group_by { |request| request.siret.first(9) }
      .map { |siren, requests| Organization.new(siren, requests, establishments) }
  end

  def organization(siren)
    organizations.find { |organization| organization.siren == siren }
  end

  def organizations_without_data_protection_officer
    organizations.reject(&:data_protection_officer_complete?)
  end

  def common_data_protection_officer
    officers = organizations.map(&:data_protection_officer).uniq

    officers.first if officers.one? && organizations.first.data_protection_officer_complete?
  end

  def data_protection_officer_shared_form?
    return @data_protection_officer_shared_form if defined?(@data_protection_officer_shared_form)

    @data_protection_officer_shared_form = organizations.one? || organizations.none?(&:data_protection_officer?)
  end

  def small?
    pending_requests.size <= SMALL_SIZE
  end

  def single?
    pending_requests.one?
  end

  def establishment(siret)
    establishments[siret]
  end

  def masked_contact_email
    local, domain = contact_email.to_s.split('@', 2)

    "#{local.to_s.split('.').map { |part| "#{part.first}***" }.join('.')}@#{domain}"
  end

  def datapass_data
    @datapass_data ||= editor_delegation_campaign.datapass_data
  end

  private

  def establishments
    @establishments ||= ::Organization.where(siret: requests.select(:siret)).index_by(&:siret)
  end
end
