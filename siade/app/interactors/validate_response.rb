class ValidateResponse < ApplicationInteractor
  include ResourceHelpers

  def self.inherited(klass)
    klass.class_eval do
      before do
        context.errors ||= []
      end

      after do
        if context.status.nil?
          status_not_defined!
        end
      end
    end
  end

  def call
    fail 'should be implemented in inherited class'
  end

  protected

  def ok!
    context.status = 200
  end

  def internal_error!(message = nil)
    context.errors << ::ProviderInternalServerError.new(context.provider_name, message)
    context.status = 502
    context.fail!
  end

  def invalid_provider_response!(message = nil)
    internal_error!(message)
  end

  def resource_not_found!(message = not_found_message)
    context.errors << ::NotFoundError.new(context.provider_name, message)
    context.status = 404
    context.fail!
  end

  private

  def not_found_message
    'Le siret ou siren indiqué n\'existe pas, n\'est pas connu ou ne comporte aucune information pour cet appel'
  end

  def status_not_defined!
    raise RetrieverOrganizer::StatusNotDefined
  end
end
