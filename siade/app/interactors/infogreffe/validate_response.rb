class Infogreffe::ValidateResponse < ValidateResponse
  def call
    return if http_ok? && payload_has_siren?

    resource_not_found!(:siren) if not_found_in_body?

    temporary_credentials_error! if temporary_credentials_error?
    cant_generate_command_error! if cant_generate_command_error?

    provider_unavailable! if provider_unavailable_in_body?

    unknown_provider_response!
  end

  private

  def not_found_in_body?
    potential_error.present? &&
      not_found_codes.any? do |not_found_code|
        potential_error.starts_with?(not_found_code)
      end
  end

  def provider_unavailable_in_body?
    potential_error.present? &&
      potential_error.starts_with?(provider_unavailable_code)
  end

  def payload_has_siren?
    return false unless xml.at_css('num_ident')

    xml.at_css('num_ident').attributes['siren'].value
  end

  def xml
    @xml ||= Nokogiri.XML(body)
  end

  def potential_error
    potential_error = xml.xpath('//return/text()').last.try(:text).try(:strip)

    return unless potential_error =~ /^\d{2}/

    potential_error
  end

  def not_found_codes
    %w[
      006
      008
      065
      081
    ]
  end

  def cant_generate_command_code
    '014'
  end

  def provider_unavailable_code
    '999'
  end

  def temporary_credentials_error?
    potential_error.present? &&
      potential_error.starts_with?(temporary_credentials_error_code)
  end

  def cant_generate_command_error?
    potential_error.present? &&
      potential_error.starts_with?(cant_generate_command_code)
  end

  def infogreffe_specific_error!(kind)
    context.errors << InfogreffeError.new(kind)
    context.fail!
  end

  def cant_generate_command_error!
    infogreffe_specific_error!(:cant_generate_command)
  end

  def temporary_credentials_error!
    infogreffe_specific_error!(:temporary_credentials_error)
  end

  def temporary_credentials_error_code
    '003'
  end

  def resource_not_found!(resource)
    error = build_error(::NotFoundError, not_found_message(resource))

    error.add_meta(
      provider_error: extract_provider_error_attributes
    )

    fail_with_error!(error)
  end

  def extract_provider_error_attributes
    return {} if potential_error.blank?

    {
      code: potential_error[0..2],
      message: potential_error[5..-2]
    }
  end
end
