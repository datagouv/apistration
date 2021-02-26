class Documents::Base64Decode < ApplicationInteractor
  before do
    context.errors ||= []
  end

  def call
    context.content = Base64.strict_decode64(encoded_content)
  rescue ArgumentError
    errors << 'Erreur lors du décodage : invalide Base64 format'
    context.fail!
  end

  private

  def encoded_content
    context.content
  end

  def errors
    context.errors
  end
end
