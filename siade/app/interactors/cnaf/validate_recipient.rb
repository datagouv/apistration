class CNAF::ValidateRecipient < ValidateParamInteractor
  def call
    invalid_recipient! unless ValidateSiret.call(params: { siret: params[:recipient] }).success?
  end

  private

  def invalid_recipient!
    context.errors << InvalidRecipientError.new

    mark_as_error!
  end
end
