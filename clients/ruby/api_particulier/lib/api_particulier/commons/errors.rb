# frozen_string_literal: true
# DO NOT EDIT — generated from clients/ruby/commons/ (source digest: 903f3b3aca1a59a6cb1a53ab98f72c365486fc1f).
# Regenerate via clients/ruby/bin/sync_commons.

module ApiParticulier::Commons
  class Error < StandardError
    attr_reader :http_status, :errors, :method, :url

    def initialize(message = nil, http_status: nil, errors: [], method: nil, url: nil)
      super(message || default_message(http_status, errors))
      @http_status = http_status
      @errors = errors || []
      @method = method
      @url = url
    end

    def first_error
      errors.first || {}
    end

    def first_error_code
      first_error['code'] || first_error[:code]
    end

    def first_error_title
      first_error['title'] || first_error[:title]
    end

    def first_error_detail
      first_error['detail'] || first_error[:detail]
    end

    def first_error_source
      first_error['source'] || first_error[:source]
    end

    def first_error_meta
      first_error['meta'] || first_error[:meta] || {}
    end

    private

    def default_message(http_status, errors)
      first = (errors || []).first || {}
      title = first['title'] || first[:title]
      detail = first['detail'] || first[:detail]
      parts = [http_status, title, detail].compact
      parts.empty? ? self.class.name : parts.join(' — ')
    end
  end

  class ClientError < Error; end
  class AuthenticationError < ClientError; end
  class AuthorizationError < ClientError; end
  class NotFoundError < ClientError; end
  class ConflictError < ClientError; end
  class ValidationError < ClientError; end

  class RateLimitError < ClientError
    attr_reader :retry_after

    def initialize(message = nil, retry_after: nil, **kwargs)
      super(message, **kwargs)
      @retry_after = retry_after
    end
  end

  class ServerError < Error; end
  class ProviderError < ServerError
    attr_reader :retry_after

    def initialize(message = nil, retry_after: nil, **kwargs)
      super(message, **kwargs)
      @retry_after = retry_after
    end
  end
  class ProviderUnavailableError < ServerError; end

  class TransportError < Error; end

  class InvalidSiretError < ArgumentError; end
  class InvalidSirenError < ArgumentError; end
  class MissingParameterError < ArgumentError; end
end
