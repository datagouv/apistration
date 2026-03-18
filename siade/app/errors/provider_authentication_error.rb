class ProviderAuthenticationError < AbstractGenericProviderError
  def subcode
    '006'
  end

  def detail
    "L'authentification auprès du fournisseur de données '#{provider_name}' a échoué"
  end
end
