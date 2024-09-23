class NotFoundError < AbstractGenericProviderError
  attr_reader :provider_name, :with_identifiant_message

  def initialize(provider_name, message = nil, with_identifiant_message = true)
    @provider_name = provider_name
    @message = message
    @with_identifiant_message = with_identifiant_message
  end

  def subcode
    '003'
  end

  def title
    'Entité non trouvée'
  end

  def kind
    :not_found
  end

  def detail
    generated_message = @message || 'Le siret ou siren indiqué n\'existe pas, n\'est pas connu ou ne comporte aucune information pour cet appel.'
    generated_message += ' Veuillez vérifier que l\'identifiant correspond au périmètre couvert par l\'API.' if @with_identifiant_message

    @detail ||= generated_message
  end
end
