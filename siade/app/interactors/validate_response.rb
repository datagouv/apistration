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

  def resource_not_found!(message = not_found_message)
    context.errors << message
    context.status = 404
    context.fail!
  end

  private

  def not_found_message
    'Le siret ou siren indiqué n\'existe pas, n\'est pas connu ou ne comporte aucune information pour cet appel'
  end
end
