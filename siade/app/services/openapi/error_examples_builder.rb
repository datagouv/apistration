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
