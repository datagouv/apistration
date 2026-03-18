class NotFoundError < AbstractGenericProviderError
  attr_reader :provider_name

  def initialize(provider_name, message=nil)
    @provider_name = provider_name
    @message = message
  end

  def subcode
    '003'
  end

  def title
    'Entité non trouvée'
  end

  def detail
    @message || 'Le siret ou siren indiqué n\'existe pas, n\'est pas connu ou ne comporte aucune information pour cet appel'
  end
end
