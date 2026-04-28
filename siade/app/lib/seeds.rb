class Seeds
  def perform
    return unless development_or_test?

    create_token(id: yes_jwt_id)
    create_token(id: no_scopes_jwt_id, scopes: [])
    create_token(id: blacklisted_jwt_id, blacklisted_at: 1.month.ago)
    create_token(id: expired_jwt_id, exp: 1.day.ago.to_i)
    create_editor_with_delegation
  end

  def yes_jwt_id
    'f5d5cb02-185a-426f-b3f4-99a25ce6cdf4'
  end

  def expired_jwt_id
    '4c63c9d9-18dc-46c6-a555-de87f643f2c0'
  end

  def blacklisted_jwt_id
    'c1578da0-52fe-4bca-bfac-b5e183e9e71c'
  end

  def create_token(params = {})
    token = Token.find_or_initialize_by(id: params[:id])

    token.assign_attributes(default_token_attributes.merge(params))
    token.authorization_request = create_authorization_request(scopes: params[:scopes] || Scope.all, **params[:authorization_request] || {})

    token.save!

    token
  end

  def create_authorization_request(authorization_request_id: nil, siret: generate_siret, scopes: Scope.all)
    authorization_request = AuthorizationRequest.find_or_initialize_by(id: authorization_request_id)

    authorization_request.assign_attributes(
      siret:,
      scopes:
    )

    authorization_request.save!

    authorization_request
  end

  private

  def default_token_attributes
    {
      iat: 1.day.ago.to_i,
      version: '1.0',
      exp: 18.months.from_now.to_i,
      scopes: Scope.all,
      extra_info: {}
    }
  end

  def development_or_test?
    Rails.env.local?
  end

  def generate_siret
    random_number = 1_000_000_000_000

    # rubocop:disable Style/MultilineBlockChain
    sum = random_number.digits.each_with_index.map { |digit, index|
      index.even? ? digit * 2 : digit
    }.sum do |value|
      value > 9 ? value - 9 : value
    end
    # rubocop:enable Style/MultilineBlockChain

    last_digit = (10 - (sum % 10)) % 10

    "#{random_number}#{last_digit}"
  end

  def no_scopes_jwt_id
    'b1578da0-52fe-4bca-bfac-b5e183e9e71c'
  end

  def editor_id
    'e0000000-0000-0000-0000-000000000001'
  end

  def editor_token_id
    'e0000000-0000-0000-0000-000000000002'
  end

  def editor_delegation_siret
    '13002526500013'
  end

  def create_editor_with_delegation
    editor = create_editor
    authorization_request = create_authorization_request(siret: editor_delegation_siret)

    delegation = EditorDelegation.find_or_initialize_by(editor:, authorization_request:)
    delegation.save!

    create_editor_token(editor)
  end

  def create_editor
    editor = Editor.find_or_initialize_by(id: editor_id)
    editor.assign_attributes(name: 'Editeur de test')
    editor.save!
    editor
  end

  def create_editor_token(editor)
    editor_token = EditorToken.find_or_initialize_by(id: editor_token_id)
    editor_token.assign_attributes(
      editor:,
      iat: 1.day.ago.to_i,
      exp: 18.months.from_now.to_i
    )
    editor_token.save!
  end
end
