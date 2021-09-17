class MI::Associations::ValidateResponse < ValidateResponse
  def call
    check_body_integrity!

    return if http_ok? && payload_valid?

    resource_not_found!(not_found_msg) if not_found_in_body?
    invalid_provider_response!
  end

  private

  def check_body_integrity!
    xml_body_as_hash
  rescue Ox::ParseError
    unknown_provider_response!
  end

  def payload_valid?
    payload_present? &&
      payload_has_name?
  end

  def not_found_in_body?
    return if xml_body_as_hash.dig(:asso, :erreur, :proxy_correspondance).blank?

    xml_body_as_hash[:asso][:erreur][:proxy_correspondance]['with statusCode: 404']
  end

  def payload_present?
    xml_body_as_hash[:asso].present?
  end

  def payload_has_name?
    return unless xml_body_as_hash[:asso][:identite]

    !xml_body_as_hash[:asso][:identite][:nom].nil?
  end

  def not_found_msg
    "L'identifiant association demandé (Numéro RNA ou Siret) n'est pas connu."
  end
end
