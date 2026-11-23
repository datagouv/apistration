class EditorDelegationBatch::Organization
  attr_reader :siren, :requests

  def initialize(siren, requests, establishments)
    @siren = siren
    @requests = requests
    @establishments = establishments
  end

  def name
    @establishments.values_at(*requests.map(&:siret)).compact.filter_map(&:denomination).first || "SIREN #{siren}"
  end

  def data_protection_officer
    lead_request.data.slice(*EditorDelegationRequest::DATA_PROTECTION_OFFICER_ATTRIBUTES)
  end

  def data_protection_officer?
    data_protection_officer.values.any?(&:present?)
  end

  def data_protection_officer_complete?
    requests.all?(&:data_protection_officer_complete?)
  end

  def lead_request
    requests.first
  end

  def update_data_protection_officer(attributes)
    requests.each { |request| request.assign_attributes(attributes) }
    return false unless lead_request.valid?(:data_protection_officer)

    EditorDelegationRequest.transaction { requests.each(&:save!) }
  end
end
