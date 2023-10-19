module HandlePingProviders
  def show
    if staging?
      render faked_ping_response
    else
      render ping_response
    end
  end

  protected

  def provider_param
    fail NotImplementedError
  end

  private

  def ping_response
    PingService.new(api_kind, provider_param).perform
  end

  def staging?
    Rails.env.staging?
  end

  def faked_ping_response
    if provider_exists?
      {
        status: :ok,
        json: {
          status: :ok,
          last_update: Time.now.utc.iso8601
        }
      }
    else
      {
        status: :not_found,
        json: {}
      }
    end
  end

  def provider_exists?
    Rails.application.config_for(:pings)[api_kind].key?(provider_param.to_sym)
  end
end
