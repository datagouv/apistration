class DSNJ::ServiceNational::ValidateResponse < ValidateResponse
  def call
    unknown_provider_response! if !return_code_ok? || json_body['results'].many?

    resource_not_found! if not_found_in_body?

    return if found_in_body?

    unknown_provider_response!
  end

  private

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
