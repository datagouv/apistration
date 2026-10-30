class DocumentsProxyPingDriver < AbstractPingDriver
  ERROR_RATIO_THRESHOLD = 0.2
  MINIMUM_CALLS = 5

  private

  def build_context(driver_params)
    @routes = driver_params.fetch(:routes)
  end

  def error_statuses
    %w[502 503 504]
  end

  def error_ratio_threshold
    ERROR_RATIO_THRESHOLD
  end

  def minimum_calls
    MINIMUM_CALLS
  end

  def recently_out_of_maintenance?
    false
  end
end
