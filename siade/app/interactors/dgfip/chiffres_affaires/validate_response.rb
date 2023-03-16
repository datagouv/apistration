class DGFIP::ChiffresAffaires::ValidateResponse < ValidateResponse
  def call
    unknown_provider_response! unless http_ok?

    if null_body? || empty_liste_ca?
      resource_not_found!
    elsif invalid_json? || !json_body.key?('liste_ca')
      unknown_provider_response!
    end
  end

  private

  def null_body?
    ['', 'null'].include?(body)
  end

  def empty_liste_ca?
    valid_json? &&
      json_body.key?('liste_ca') &&
      json_body['liste_ca'].blank?
  end
end
