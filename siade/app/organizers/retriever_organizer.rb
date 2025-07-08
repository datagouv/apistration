class RetrieverOrganizer < ApplicationOrganizer
  class InvalidProviderName < StandardError; end

  def self.inherited(klass)
    klass.class_eval do
      before do
        handles_provider
        context.resource  = nil
        context.errors    = []
        context.cacheable = false
        provider_in_maintenance! if in_maintenance?
      end
    end
  end

  def call
    mark_organizer_as_called_to_run_rollback_on_fail!
    super
  rescue StandardError => e
    monitoring_service.set_retriever_context(context)
    raise e
  end

  def rollback
    track_errors
  end

  protected

  def provider_name
    fail NotImplementedError
  end

  private

  def track_errors
    errors_to_track.each do |error|
      track_error(error)
    end
  end

  def errors_to_track
    provider_errors
  end

  def track_error(error)
    monitoring_service.track_provider_error(error)
  end

  def provider_errors
    context.errors.select do |error|
      error.kind == :provider_unknown_error
    end
  end

  def invalid_provider_name!
    raise InvalidProviderName
  end

  def provider_name_valid?
    ErrorsBackend.instance.provider_code_from_name(context.provider_name).present?
  end

  def mark_organizer_as_called_to_run_rollback_on_fail!
    context.called!(self)
  end

  def handles_provider
    context.provider_name = provider_name
    invalid_provider_name! unless provider_name_valid?
    monitoring_service.set_provider(provider_name)
  end

  def provider_in_maintenance!
    context.errors << MaintenanceError.new(context.provider_name)
    context.fail!
  end

  def monitoring_service
    MonitoringService.instance
  end

  def in_maintenance?
    MaintenanceService.new(context.provider_name).on?
  end
end
