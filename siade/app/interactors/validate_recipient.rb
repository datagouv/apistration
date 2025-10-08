class ValidateRecipient < ValidateParamInteractor
  def call
    invalid_recipient! unless ValidateSiret.call(params: { siret: context.recipient }).success?
  end

  protected

  def recipient
    context.recipient
  end

  private

  def invalid_recipient!
    context.errors << InvalidRecipientError.new
    track_invalid_recipient

    mark_as_error!
  end

  def track_invalid_recipient
    MonitoringService.instance.track_with_added_context(
      'info',
      'Invalid recipient',
      {
        recipient: context.recipient || 'empty recipient'
      }
    )
  end
end
