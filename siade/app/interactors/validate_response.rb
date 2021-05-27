class ValidateResponse < ApplicationInteractor
  include ResourceHelpers

  def self.inherited(klass)
    klass.class_eval do
      before do
        context.errors ||= []
      end
    end
  end

  def call
    fail 'should be implemented in inherited class'
  end

  protected

  def invalid_provider_response!(message = nil)
    context.errors << ::ProviderInternalServerError.new(context.provider_name, message)
    context.fail!
  end

  def unknown_provider_response!(message = nil)
    context.errors << ::ProviderUnknownError.new(context.provider_name, message)
    context.fail!
  end

  def resource_not_found!(message = not_found_message)
    context.errors << ::NotFoundError.new(context.provider_name, message)
    context.fail!
  end

  private

  def not_found_message
    'Le siret ou siren indiqué n\'existe pas, n\'est pas connu ou ne comporte aucune information pour cet appel'
  end
end
