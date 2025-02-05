class DGFIP::ChiffresAffaires::ValidateResponse < DGFIP::ValidateResponse
  def call
    handle_errors

    if null_body? || empty_liste_ca?
      resource_not_found!
    elsif invalid_json? || !json_body.key?('liste_ca')
      unknown_provider_response!
    end
  end

  private

  def handle_errors
    resource_not_found! if not_found?
    temporary_error! if runtime_error?
    unknown_provider_response! unless http_ok?
  end

  def not_found?
    http_not_found? ||
      http_code == 204
  end

  def null_body?
    ['', 'null'].include?(body)
  end

  def empty_liste_ca?
    valid_json? &&
      json_body.key?('liste_ca') &&
      json_body['liste_ca'].blank?
  end
end
