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
    generated_message = @message || 'L\identifiant indiqué n\'existe pas, n\'est pas connu ou ne comporte aucune information pour cet appel.'
    generated_message += ' Veuillez vérifier que l\'identifiant correspond au périmètre couvert par l\'API.' if @with_identifiant_message

    @detail ||= generated_message
  end
end
