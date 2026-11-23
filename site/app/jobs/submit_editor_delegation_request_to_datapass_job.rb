class SubmitEditorDelegationRequestToDatapassJob < ApplicationJob
  def perform(editor_delegation_request_id, consents)
    request = EditorDelegationRequest.find(editor_delegation_request_id)
    return unless request.submitted?

    EditorDelegationRequest::DatapassSubmission.new(request, signatory: request.submitted_by_user, consents: consents.symbolize_keys).call
  rescue DatapassAPIClient::UnprocessableEntity => e
    request.refused_by_datapass!(e.errors.filter_map { |detail| detail['detail'] }.uniq.to_sentence.presence || e.message)
  end
end
