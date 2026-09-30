class DatapassAPIClient
  class Error < StandardError
    attr_reader :status, :errors

    def initialize(message = nil, status: nil, errors: [])
      super(message)
      @status = status
      @errors = errors
    end
  end

  class Unauthorized < Error; end
  class NotFound < Error; end
  class UnprocessableEntity < Error; end
end
