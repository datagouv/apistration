class MI::Associations::Documents::ValidateResponse < MI::Associations::ValidateResponse
  declares_no_specific_errors!

  def call
    temporary_error! if body.blank?

    handle_not_found! if http_not_found?

    resource_not_found!(:siret_or_rna) if http_bad_request?

    unknown_provider_response! unless valid_documents_payload?

    resource_not_found!(:siret_or_rna) unless payload_has_documents?
  end

  private

  def valid_documents_payload?
    http_ok? && valid_json? && payload_valid?
  end

  def handle_not_found!
    invalid_json? ? provider_unavailable! : resource_not_found!(:siret_or_rna)
  end

  def payload_has_documents?
    return false unless body_as_hash.dig(:asso, :documents)

    body_as_hash[:asso][:documents][:nbDocRna].to_i.positive?
  end
end
