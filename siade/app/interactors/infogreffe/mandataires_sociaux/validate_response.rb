class Infogreffe::MandatairesSociaux::ValidateResponse < ValidateResponse
  def call
    return if http_ok? && payload_has_siren?

    resource_not_found!(:siren) if not_found_in_body?
    unknown_provider_response!
  end

  private

  def not_found_in_body?
    body.include?('006 -DOSSIER NON TROUVE DANS LA BASE DE GREFFES')
  end

  def payload_has_siren?
    return unless xml.at_css('num_ident')

    xml.at_css('num_ident').attributes['siren'].value
  end

  def xml
    Nokogiri.XML(body)
  end
end
