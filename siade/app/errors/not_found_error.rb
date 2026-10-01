class NotFoundError < AbstractGenericProviderError
  def self.build_example(provider_name:, provider: nil, title: 'Entité non trouvée', detail: nil, **)
    new(provider || provider_name, detail, title:, with_identifiant_message: detail.nil?)
  end

  attr_reader :provider_name, :with_identifiant_message, :title

  def initialize(provider_name, message = nil, title: 'Entité non trouvée', with_identifiant_message: true)
    @provider_name = provider_name
    @message = message
    @with_identifiant_message = with_identifiant_message
    @title = title
  end

  def subcode
    '003'
  end

  def kind
    :not_found
  end

  def detail
    generated_message = @message || 'Le ou les paramètre(s) d\'entrée n\'existent pas, ne sont pas connus, ou ne comportent aucune information pour cet appel.'
    generated_message += ' Veuillez vérifier que votre recherche est couverte par le périmètre de l\'API.' if @with_identifiant_message

    @detail ||= generated_message
  end
end
