class UnexpectedRedirectionError < ProviderInternalServerError
  attr_reader :redirect_location

  def initialize(provider_name, redirect_location)
    @redirect_location = redirect_location
    super(provider_name)
  end

  def detail
    'Erreur serveur inattendue du fournisseur de données'
  end
end
