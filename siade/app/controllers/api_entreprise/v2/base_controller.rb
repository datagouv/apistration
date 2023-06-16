class APIEntreprise::V2::BaseController < ::APIEntrepriseController
  include OrganizersMethodsHelpers
  include InterceptWithOpenAPIMockedPayloadInStaging

  rescue_from ::ProviderInMaintenance, with: :provider_in_maintenance

  protected

  def provider_in_maintenance(exception)
    render error_json(MaintenanceError.new(exception.provider_name), status: 502)
  end

  def write_retriever_cache(retriever, expires_in:)
    EncryptedCache.write(cache_key, retriever, expires_in: 24.hours.to_i)
  end

  def cache_key
    request.path
  end

  def cached_retriever
    @cached_retriever ||= EncryptedCache.read(cache_key)
  end

  def at_least_one_error_cant_be_cached?(retriever)
    at_least_one_error_kind_of?(:network_error, retriever)
  end
end
