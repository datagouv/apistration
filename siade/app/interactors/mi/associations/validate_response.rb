class MI::Associations::ValidateResponse < ValidateResponse
  def call
    check_body_integrity!

    resource_not_found!(id_param) if not_found_in_body? || !valid_association?

    return if http_ok? && payload_valid?

    unknown_provider_response!
  end

  private

  def id_param
    return :siret_or_rna if context.params[:siret_or_rna]

    :siren_or_rna
  end

  def check_body_integrity!
    xml_body_as_hash
  rescue Ox::ParseError
    unknown_provider_response!
  end

  def valid_association?
    payload_valid? &&
      (from_repertoire? || juridically_an_asso?)
  end

  def from_repertoire?
    rna_id? || alsace_moselle?
  end

  def payload_valid?
    payload_present? &&
      payload_has_id_correspondance?
  end

  def rna_id?
    return false unless xml_body_as_hash[:asso][:identite]

    !xml_body_as_hash[:asso][:identite][:id_rna].nil?
  end

  def alsace_moselle?
    return false unless xml_body_as_hash[:asso][:identite]

    xml_body_as_hash[:asso][:identite][:regime] == 'alsaceMoselle'
  end

  def juridically_an_asso?
    return false unless xml_body_as_hash[:asso][:identite]

    code_categorie_juridique = xml_body_as_hash[:asso][:identite][:id_forme_juridique]

    monitor_association_without_rna(id_param) if xml_body_as_hash[:asso][:identite][:regime] == 'loi1901'

    %w[9220 9230 9260].include?(code_categorie_juridique)
  end

  def not_found_in_body?
    return false if xml_body_as_hash.dig(:asso, :erreur, :proxy_correspondance).blank?

    xml_body_as_hash[:asso][:erreur][:proxy_correspondance]['with statusCode: 404']
  end

  def payload_present?
    xml_body_as_hash[:asso].present?
  end

  def payload_has_id_correspondance?
    return false unless xml_body_as_hash[:asso][:identite]

    !xml_body_as_hash[:asso][:identite][:id_correspondance].nil?
  end

  def monitor_association_without_rna(id_param)
    MonitoringService.instance.track_with_added_context(
      'info',
      'Association without RNA detected',
      {
        siret_or_rna: id_param
      }
    )
  end
end
