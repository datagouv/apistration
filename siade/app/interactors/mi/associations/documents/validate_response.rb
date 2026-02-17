class MI::Associations::Documents::ValidateResponse < MI::Associations::ValidateResponse
  def call
    check_body_integrity!

    return if http_ok? && payload_valid? && payload_has_documents?

    provider_unavailable! unless payload_present?

    resource_not_found!(:siret_or_rna) if not_found_in_body? || !payload_has_documents?

    unknown_provider_response!
  end

  private

  def payload_has_documents?
    return false unless xml_body_as_hash.dig(:asso, :documents)

    xml_body_as_hash[:asso][:documents][:nbDocRna].to_i.positive?
  end
end
