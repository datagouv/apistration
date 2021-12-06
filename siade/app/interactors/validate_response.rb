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
    fail NotImplementedError
  end

  protected

  def invalid_json?
    json_body

    false
  rescue JSON::ParserError
    true
  end

  def build_error(error_klass, message = nil)
    error_klass.new(context.provider_name, message)
  end

  def fail_with_error!(error)
    context.errors << error
    context.fail!
  end

  def invalid_provider_response!(message = nil)
    fail_with_error!(build_error(::ProviderInternalServerError, message))
  end

  def unknown_provider_response!(message = nil)
    fail_with_error!(build_error(::ProviderUnknownError, message))
  end

  def resource_not_found!(message = not_found_message)
    fail_with_error!(build_error(::NotFoundError, message))
  end

  private

  def not_found_message
    'Le siret ou siren indiqué n\'existe pas, n\'est pas connu ou ne comporte aucune information pour cet appel'
  end
end
