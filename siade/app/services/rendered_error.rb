class RenderedError
  def self.capture(errors)
    Current.rendered_error ||= [*errors].first
  end

  def self.log_fields
    code = error_code

    return {} if code.blank?

    {
      error_code: code,
      error_provider_code: code[0..1],
      error_subcode: code[2..]
    }.merge(provider_error_fields)
  end

  def self.error_code
    Current.rendered_error&.code
  rescue StandardError
    nil
  end

  def self.provider_error_fields
    provider_error_code = Current.rendered_error.meta[:provider_error_code]

    return {} if provider_error_code.blank?

    { provider_error_code: provider_error_code.to_s }
  rescue StandardError
    {}
  end
end
