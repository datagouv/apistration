class MI::Associations::ValidateResponse < ValidateResponse
  include MI::Associations::PayloadParsing

  declares_no_specific_errors!

  def call
    internal_server_error! if http_internal_error?

    resource_not_found!(id_param) if http_not_found? || http_bad_request?

    check_body_integrity!

    unknown_provider_response! unless http_ok? && payload_valid?

    resource_not_found!(id_param) unless valid_association?
  end

  private

  def id_param
    return :siret_or_rna if context.params[:siret_or_rna]

    :siren_or_rna
  end

  def check_body_integrity!
    temporary_error! if body.blank?

    body_as_hash
  rescue JSON::ParserError
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
    return false unless body_as_hash[:asso][:identite]

    !body_as_hash[:asso][:identite][:id_rna].nil?
  end

  def alsace_moselle?
    return false unless body_as_hash[:asso][:identite]

    body_as_hash[:asso][:identite][:regime] == 'alsaceMoselle'
  end

  def juridically_an_asso?
    return false unless body_as_hash[:asso][:identite]

    code_categorie_juridique = body_as_hash[:asso][:identite][:id_forme_juridique]

    monitor_association_without_rna(id_param) if body_as_hash[:asso][:identite][:regime] == 'loi1901'

    code_categorie_juridique.to_s.start_with?('922') ||
      %w[9230 9260].include?(code_categorie_juridique)
  end

  def payload_present?
    body_as_hash&.dig(:asso).present?
  end

  def payload_has_id_correspondance?
    return false unless body_as_hash[:asso][:identite]

    !body_as_hash[:asso][:identite][:id_correspondance].nil?
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
