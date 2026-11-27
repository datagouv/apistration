class SubmitEditorDelegationRequestToDatapassJob < ApplicationJob
  UNREACHABLE_DATAPASS_REASON = 'DataPass n’a pas pu recevoir la demande, soumettez-la à nouveau'.freeze

  after_discard do |job|
    EditorDelegationRequest.find(job.arguments.first).refused_by_datapass!(UNREACHABLE_DATAPASS_REASON)
  end

  def perform(editor_delegation_request_id, consents)
    request = EditorDelegationRequest.find(editor_delegation_request_id)
    return unless request.submitted?

    EditorDelegationRequest::DatapassSubmission.new(request, signatory: request.submitted_by_user, consents: consents.symbolize_keys).call
  rescue DatapassAPIClient::UnprocessableEntity => e
    request.refused_by_datapass!(e.errors.filter_map { |detail| detail['detail'] }.uniq.to_sentence.presence || e.message)
  end
end
