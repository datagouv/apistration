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

  def all_scopes
    Rails.application.config_for(:authorizations).values.flatten.uniq
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
        scopes: all_scopes
      }.merge(params)
    )

    token.save!
  end

  def no_scopes_jwt_id
    'b1578da0-52fe-4bca-bfac-b5e183e9e71c'
  end
end
