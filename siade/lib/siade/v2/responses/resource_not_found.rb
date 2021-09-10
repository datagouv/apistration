class SIADE::V2::Responses::ResourceNotFound
  attr_accessor :body, :http_code, :errors

  def initialize(provider_name)
    @body = ''
    @http_code = 404
    @errors = [
      ::NotFoundError.new(
        provider_name,
        'Le siret ou siren indiqué n\'existe pas, n\'est pas connu ou ne comporte aucune information pour cet appel'
      )
    ]
  end

  attr_reader :errors
end
