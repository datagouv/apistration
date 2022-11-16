class DGFIP::ChiffresAffaires::ValidateResponse < ValidateResponse
  def call
    unknown_provider_response! unless http_ok?

    if ['', 'null'].include?(body)
      resource_not_found!
    elsif invalid_json? || json_is_not_valid?
      unknown_provider_response!
    end
  end

  private

  def json_is_not_valid?
    json_body['liste_ca'].blank? ||
      Array.wrap(json_body['liste_ca']).any? { |ca_json| ca_json['ca'].blank? || ca_json['dateFinExercice'].blank? }
  end
end
