class Openapi::ErrorExamplesBuilder
  def build_from_error(error, key)
    {
      key => {
        'value' => error_payload(error),
        'summary' => error.title,
        'description' => error.detail
      }
    }
  end

  def build_422_for_params(path_params:, mandatory_params:)
    examples = {}

    path_params.each do |param|
      error = UnprocessableEntityError.new(param)
      examples.merge!(build_from_error(error, "unprocessable_content_error_#{param}_error"))
    end

    mandatory_params.each do |param|
      error = MissingMandatoryParamError.new(param)
      examples.merge!(build_from_error(error, "missing_mandatory_params_#{param}_error"))
    end

    examples
  end

  private

  def error_payload(error)
    {
      'errors' => [
        error_hash(error)
      ]
    }
  end

  def error_hash(error)
    {
      'code' => error.code,
      'title' => error.title,
      'detail' => error.detail,
      'source' => error.source&.deep_stringify_keys,
      'meta' => error.meta&.deep_stringify_keys
    }
  end
end
