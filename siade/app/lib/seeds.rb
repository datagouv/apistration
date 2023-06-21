class Seeds
  def perform
    yes_jwt_id = 'f5d5cb02-185a-426f-b3f4-99a25ce6cdf4'

    token = Token.find_or_initialize_by(id: yes_jwt_id)

    token.assign_attributes(
      iat: 1.day.ago.to_i,
      version: '1.0',
      exp: 18.months.from_now.to_i,
      scopes: Rails.application.config_for(:authorizations).values.flatten.uniq,
    )

    token.save!
  end
end
