class Documents::Base64Decode < ApplicationInteractor
  before do
    context.errors ||= []
  end

  def call
    context.content = Base64.strict_decode64(encoded_content)
  rescue ArgumentError
    errors << invalid_base64_error
    context.status = 502
    context.fail!
  end

  private

  def encoded_content
    context.content
  end

  def invalid_base64_error
    BadFileFromProviderError.new(
      context.provider_name,
      :invalid_base64,
      'Erreur lors du décodage : invalide Base64 format',
    )
  end

  def errors
    context.errors
  end
end
