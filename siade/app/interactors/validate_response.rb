class ValidateResponse < ApplicationInteractor
  include ResourceHelpers

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
end
