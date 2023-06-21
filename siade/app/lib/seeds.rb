class Seeds
  def perform
    create_token(id: yes_jwt_id)
    create_token(id: no_scopes_jwt_id, scopes: [])
  end

  private

  def create_token(params={})
    token = Token.find_or_initialize_by(id: params[:id])

    token.assign_attributes(
      {
        iat: 1.day.ago.to_i,
        version: '1.0',
        exp: 18.months.from_now.to_i,
        scopes: Rails.application.config_for(:authorizations).values.flatten.uniq,
      }.merge(params)
    )

    token.save!
  end

  def yes_jwt_id
    'f5d5cb02-185a-426f-b3f4-99a25ce6cdf4'
  end

  def no_scopes_jwt_id
    'b1578da0-52fe-4bca-bfac-b5e183e9e71c'
  end
end
