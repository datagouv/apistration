class Infogreffe::ValidateResponse < ValidateResponse
  def call
    return if http_ok? && payload_has_siren?

    resource_not_found!(:siren) if not_found_in_body?
    unknown_provider_response!
  end

  private

  def not_found_in_body?
    potentiel_error.present? &&
      not_found_codes.any? do |not_found_code|
        potentiel_error.starts_with?(not_found_code)
      end
  end

  def payload_has_siren?
    return unless xml.at_css('num_ident')

    xml.at_css('num_ident').attributes['siren'].value
  end

  def xml
    @xml ||= Nokogiri.XML(body)
  end

  def potentiel_error
    xml.xpath('//return/text()').last.try(:text)
  end

  def not_found_codes
    %w[
      006
      008
    ]
  end
end
