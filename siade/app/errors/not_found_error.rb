class NotFoundError < AbstractGenericProviderError
  attr_reader :provider_name, :with_identifiant_message, :subcode, :title

  def initialize(provider_name, message = nil, title: 'Entité non trouvée', with_identifiant_message: true, subcode: '003')
    @provider_name = provider_name
    @message = message
    @with_identifiant_message = with_identifiant_message
    @subcode = subcode
    @title = title
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
