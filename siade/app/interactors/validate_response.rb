class ValidateResponse < ApplicationInteractor
  include ResourceHelpers

  def self.inherited(klass)
    klass.class_eval do
      before do
        context.errors ||= []
        context.cacheable = false
      end

      after do
        mark_payload_as_cacheable_on_success!
      end
    end
  end

  def call
    fail NotImplementedError
  end

  protected

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
    error = build_error(::ProviderUnknownError, message)

    error.add_to_monitoring_private_context({
      http_response_code: context.response.code,
      http_response_body: context.response.body,
      http_response_headers: context.response.to_hash
    })

    fail_with_error!(error)
  end

  def provider_in_maintenance!
    context.errors << MaintenanceError.new(context.provider_name)
    context.fail!
  end

  def provider_unavailable!
    context.errors << ProviderUnavailable.new(context.provider_name)
    context.fail!
  end

  def resource_not_found!(resource = nil)
    message = not_found_message(resource)

    fail_with_error!(build_error(::NotFoundError, message))
  end

  def make_payload_cacheable!
    context.cacheable = true
  end

  def mark_payload_as_cacheable_on_success!
    make_payload_cacheable!
  end

  def not_found_message(resource)
    identifiant = case resource
                  when :siret
                    'Le siret'
                  when :siren
                    'Le siren'
                  when :siret_or_rna
                    "Le siret ou l'identifiant RNA"
                  when :siret_or_siren
                    'Le siret ou le siren'
                  else
                    "L'identifiant"
                  end

    "#{identifiant} indiqué n'existe pas, n'est pas connu ou ne comporte aucune information pour cet appel."
  end
end
