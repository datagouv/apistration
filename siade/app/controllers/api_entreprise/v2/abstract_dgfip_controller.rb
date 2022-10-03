class APIEntreprise::V2::AbstractDGFIPController < APIEntreprise::V2::BaseController
  before_action :authorize_resource
  before_action :authenticate_dgfip_service

  def authorize_resource
    authorize resource_scope
  end

  def resource_scope
    fail NotImplementedError
  end

  def authenticate_dgfip_service
    dgfip_service.authenticate!

    unless dgfip_service.success?
      render_dgfip_authentication_failed
      false
    end
  rescue NoMethodError => e
    if no_cookie_on_provider_connection_refused_response?(e)
      render_dgfip_authentication_failed
      false
    else
      raise
    end
  end

  def render_dgfip_authentication_failed
    render json:   authenticate_errors,
      status: :bad_gateway
  end

  def dgfip_service
    @dgfip_service ||= AuthenticateDGFIPService.new
  end

  def authenticate_errors
    ErrorsSerializer.new(
      [
        ProviderAuthenticationError.new('DGFIP - Adélie')
      ],
      format: error_format
    ).as_json
  end

  def write_retriever_cache(retriever)
    EncryptedCache.write(cache_key, retriever, expires_in: until_next_dgfip_update_in_seconds)
  end

  def cached_retriever
    @cached_retriever ||= EncryptedCache.read(cache_key)
  end

  def cache_key
    request.path
  end

  def until_next_dgfip_update_in_seconds
    if (0..3).include?(now.hour)
      ((now.beginning_of_day + 3.hours) - now).to_i
    else
      ((now.end_of_day + 3.hours) - now).to_i
    end
  end

  private

  def no_cookie_on_provider_connection_refused_response?(exception)
    exception.name == :cookie &&
      exception.receiver.instance_of?(SIADE::V2::Responses::ServiceUnavailable)
  end

  def now
    @now ||= Time.zone.now
  end
end
