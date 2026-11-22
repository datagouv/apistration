class ApplicationPingDriver
  PROVIDER_TIMEOUT = 5
  STATEMENT_TIMEOUT = '4s'.freeze

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

  def within_provider_timeout(&)
    Timeout.timeout(PROVIDER_TIMEOUT, &)
  end

  def within_statement_timeout
    ApplicationRecord.with_connection do |connection|
      connection.transaction do
        connection.execute("SET LOCAL statement_timeout = '#{STATEMENT_TIMEOUT}'")
        yield
      end
    end
  end
end
