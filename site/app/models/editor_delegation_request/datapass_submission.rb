class EditorDelegationRequest::DatapassSubmission
  SUBMITTABLE_STATES = %w[draft changes_requested].freeze

  attr_reader :request, :signatory, :consents

  def initialize(request, signatory:, consents:)
    @request = request
    @signatory = signatory
    @consents = consents
  end

  def call
    return if received_by_datapass?

    id = demande_id
    client.attach_documents(id, documents) if documents.any?
    client.submit_demande(id, consentement: consents)
  end

  private

  def received_by_datapass?
    external_id = request.authorization_request.external_id

    external_id.present? && SUBMITTABLE_STATES.exclude?(client.get_demande(external_id)['state'])
  end

  def demande_id
    authorization_request = request.authorization_request

    if authorization_request.external_id.present?
      client.update_demande(authorization_request.external_id, { data:, metadata: })
    else
      authorization_request.update!(external_id: create_demande['id'].to_s)
    end

    authorization_request.external_id
  end

  def create_demande
    client.create_demande(
      form_uid: request.editor_delegation_campaign.datapass_form_uid,
      organization: { siret: request.siret },
      applicant: { email: signatory.email, given_name: signatory.first_name, family_name: signatory.last_name }.compact,
      data:,
      metadata:
    )
  end

  def data
    request.editor_delegation_campaign.datapass_data.merge(request.datapass_data_protection_officer)
  end

  def documents
    request.cadre_juridique_document.attached? ? { 'cadre_juridique_document' => request.cadre_juridique_document } : {}
  end

  def metadata
    request.fake_data_protection_officer_phone_number? ? { fake_dpo_phone_number: true } : {}
  end

  def client
    @client ||= DatapassAPIClient.new
  end
end
