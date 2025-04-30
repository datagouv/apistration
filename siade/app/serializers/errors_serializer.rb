class ErrorsSerializer < ActiveModel::Serializer
  attribute :errors

  def errors
    object.map do |error_handler|
      public_send(format, error_handler)
    end
  end

  def flat(error_handler)
    error_handler.detail
  end

  def json_api(error_handler)
    {
      code: error_handler.code,
      title: error_handler.title,
      detail: error_handler.detail,
      source: error_handler.source,
      meta: error_handler.meta
    }.compact
  end

  private

  def format
    @format ||= @instance_options.fetch(:format, default_format)
  end

  def default_format
    :json_api
  end
end
