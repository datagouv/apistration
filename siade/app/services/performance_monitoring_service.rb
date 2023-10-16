require 'singleton'

class PerformanceMonitoringService
  include Singleton

  attr_writer :enable

  def track(op:, description:)
    transaction = Sentry.get_current_scope&.get_transaction

    if transaction && enable?
      result = nil

      transaction.with_child_span(op:, description:) do
        result = yield
      end

      result
    else
      yield
    end
  end

  def enable?
    @enable
  end
end
