class ApplicationPingDriver
  def initialize(driver_params)
    build_context(driver_params)
  end

  def perform
    fail NotImplementedError
  end

  private

  def build_context(driver_params)
    fail NotImplementedError
  end
end
