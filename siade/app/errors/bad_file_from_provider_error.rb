class BadFileFromProviderError < ApplicationError
  def initialize(provider_name, kind, message)
    @provider_name = provider_name
    @kind = kind.to_sym
    @message = message
  end

  def code
    @code = "#{errors_backend.provider_code_from_name(@provider_name)}#{subcode}"
  end

  def title
    'Fichier renvoyé par le fournisseur de données non valide'
  end

  def detail
    @message
  end

  def kind
    :provider_error
  end

  protected

  def subcode
    {
      invalid_base64: '051',
      timeout_error: '052',
      http_error: '053',
      invalid_url: '054',
      invalid_extension: '055'
    }.fetch(@kind) do
      raise KeyError, "#{@kind} is not a valid kind name"
    end
  end
end
