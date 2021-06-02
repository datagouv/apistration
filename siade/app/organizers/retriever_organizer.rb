class RetrieverOrganizer < ApplicationOrganizer
  class InvalidProviderName < StandardError; end

  def self.inherited(klass)
    klass.class_eval do
      before do
        context.provider_name = provider_name
        invalid_provider_name! unless provider_name_valid?
        context.resource = nil
        context.errors   = []
      end
    end
  end

  def call
    mark_organizer_as_called_to_run_rollback_on_fail!
    super
  end

  def rollback
    track_providers_errors
  end

  protected

  def provider_name
    fail 'should be implemented in inherited class'
  end

  private

  def track_providers_errors
    if context.errors.any?
      context.errors.select do |error|
        error.kind == :provider_error
      end.each do |provider_error|
        MonitoringService.instance.track_provider_error(provider_error)
      end
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
end
