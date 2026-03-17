class CNAVPingDriver < AbstractPingDriver
  private

  attr_reader :provider

  def error_statuses
    %w[502 503 504]
  end

  def build_context(driver_params)
    @routes = driver_params.fetch(:routes)
    @provider = driver_params.fetch(:provider)
  end
end
