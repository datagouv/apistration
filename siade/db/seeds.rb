return if Rails.env.production?

class Token
  def readonly?
    false
  end
end

yes_jwt_id = '3d4706c4-7f5e-4442-a734-00d6c675f3c9'

token = Token.find_or_initialize_by(id: yes_jwt_id)

token.assign_attributes(
  iat: 1.day.ago.to_i,
  version: '1.0',
  exp: 18.months.from_now.to_i,
  scopes: Rails.application.config_for(:authorizations).values.flatten.uniq,
)

token.save!
