class DatapassWebhook::VerifySignature < ApplicationInteractor
  def call
    context.fail!(message: 'invalid_signature') unless HubSignature.new(context.signature, context.body).valid?
  end
end
