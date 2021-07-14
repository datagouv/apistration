class PartialContentError < AbstractGenericProviderError
  attr_reader :key

  def initialize(key, provider_name)
    @key = key
    super(provider_name)
  end

  def subcode
    '010'
  end

  def detail
    "Le champ '#{key}' est absent de la réponse du fournisseur de données"
  end

  def kind
    :partial_content
  end
end
