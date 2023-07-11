class Seeds
  def perform
    return unless development_or_test?

    create_token(id: yes_jwt_id)
    create_token(id: no_scopes_jwt_id, scopes: [])
    create_token(id: blacklisted_jwt_id, blacklisted: true)
  end

  def yes_jwt_id
    'f5d5cb02-185a-426f-b3f4-99a25ce6cdf4'
  end

  def blacklisted_jwt_id
    'c1578da0-52fe-4bca-bfac-b5e183e9e71c'
  end

  private

  def development_or_test?
    Rails.env.development? || Rails.env.test?
  end

  def create_token(params = {})
    token = Token.find_or_initialize_by(id: params[:id])

    token.assign_attributes(
      {
        iat: 1.day.ago.to_i,
        version: '1.0',
        exp: 18.months.from_now.to_i,
        scopes: Scope.all
      }.merge(params)
    )

    token.authorization_request = create_authorization_request(**params[:authorization_request] || {})

    token.save!
  end

  def create_authorization_request(authorization_request_id: nil, siret: generate_siret)
    authorization_request = AuthorizationRequest.find_or_initialize_by(id: authorization_request_id)

    authorization_request.assign_attributes(
      siret:
    )

    authorization_request.save!

    authorization_request
  end

  def generate_siret
    random_number = 10_000_000

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
end
