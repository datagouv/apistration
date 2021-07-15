module RSWagCommonsResponses
  def common_action_attributes
    produces 'application/json'

    parameter name: :context, in: :query, type: :string
    parameter name: :recipient, in: :query, type: :string
    parameter name: :object, in: :query, type: :string

    security [jwt_bearer_token: []]
  end

  def unauthorized_request(&block)
    include_context 'Valid mandatory params and no token'

    response '403', 'Non autorisé' do
      description "Le jeton est absent"

      block.call if block_given?

      run_test!
    end
  end

  def forbidden_request(&block)
    include_context 'Valid mandatory params and unauthorized token'

    response '403', 'Accès interdit' do
      description "Le jeton ne possède pas les droits nécessaires"

      block.call if block_given?

      run_test!
    end
  end
end

