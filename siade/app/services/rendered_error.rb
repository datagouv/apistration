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
    }
  end

  def self.error_code
    Current.rendered_error&.code
  rescue StandardError
    nil
  end
end
