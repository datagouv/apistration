class DSNJ::ServiceNational::ValidateResponse < ValidateResponse
  def call
    unknown_provider_response! if !return_code_ok? || json_body['results'].many?

    resource_not_found! if not_found_in_body?

    return if found_in_body?

    unknown_provider_response!
  end

  after do
    track_apostrophe_match if found_in_body? && params_contain_apostrophe?
  end

  private

  def params_contain_apostrophe?
    return false unless context.params

    nom = context.params[:nom_naissance].to_s
    prenoms = context.params[:prenoms]&.join(' ').to_s
    nom.include?("'") || prenoms.include?("'")
  end

  def track_apostrophe_match
    MonitoringService.instance.track_with_added_context(
      'info',
      'DSNJ ServiceNational: successful match with apostrophe in name or first_name',
      { encrypted_params: DataEncryptor.new(context.params.to_json).encrypt.to_s }
    )
  end

  def return_code_ok?
    json_body['return_code'] == 'OK'
  end

  def not_found_in_body?
    json_body['results'].try(:first).try(:[], 'code') == 'NON_TROUVE'
  end

  def found_in_body?
    json_body['results'].try(:first).try(:[], 'code') == 'OK'
  end
end
