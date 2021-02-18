class ValidateResponse < ApplicationInteractor
  def self.inherited(klass)
    klass.class_eval do
      before do
        context.errors ||= []
      end
    end
  end

  protected

  def invalid_provider_response!(message = 'Invalid provider response')
    context.errors << message
    context.status = 502
    context.fail!
  end

  def response
    context.response
  end

  def http_code
    response.code.to_i
  end

  def body
    response.body
  end

  def json_body
    JSON.parse(body)
  end
end
