class MI::Associations::ValidateResponse < ValidateResponse
  def call
    check_body_integrity!

    resource_not_found!(:siret_or_rna) if not_found_in_body? || not_valid_association?

    return if http_ok? && payload_valid?

    unknown_provider_response!
  end

  private

  def check_body_integrity!
    xml_body_as_hash
  rescue Ox::ParseError
    unknown_provider_response!
  end

  def not_valid_association?
    payload_valid? && (
      rna_id_missing? &&
        !alsace_moselle?
    )
  end

  def payload_valid?
    payload_present? &&
      payload_has_id_correspondance?
  end

  def rna_id_missing?
    xml_body_as_hash[:asso][:identite][:id_rna].nil?
  end

  def alsace_moselle?
    xml_body_as_hash[:asso][:identite][:regime] == 'alsaceMoselle'
  end

  def not_found_in_body?
    return if xml_body_as_hash.dig(:asso, :erreur, :proxy_correspondance).blank?

    xml_body_as_hash[:asso][:erreur][:proxy_correspondance]['with statusCode: 404']
  end

  def payload_present?
    xml_body_as_hash[:asso].present?
  end

  def payload_has_id_correspondance?
    return unless xml_body_as_hash[:asso][:identite]

    !xml_body_as_hash[:asso][:identite][:id_correspondance].nil?
  end
end
