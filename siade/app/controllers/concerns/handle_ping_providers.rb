module HandlePingProviders
  def index
    render json: valid_pings, status: :ok
  end

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

  def valid_pings
    PingService.config[api_kind].each_with_object([]) do |(provider, config), result|
      next unless config[:status_page].present? && config[:status_page][:name].present?

      result << {
        name: config[:status_page][:name],
        url: ping_url(provider)
      }
    end
  end

  def provider_exists?
    PingService.config[api_kind].key?(provider_param.to_sym)
  end

  def ping_url(provider)
    public_send("#{api_kind}_ping_provider_url", provider)
  end
end
