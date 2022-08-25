class CNOUS::Authenticate < GetOAuth2Token
  private

  def set_headers(request)
    request['Authorization'] = "Basic #{client_credentials_header}"
  end

  def access_token(response)
    authorization = response['Authorization']
    authorization.match(/^Bearer\s(.*\z)/)[1]
  end

  def expires_in(response)
    token = access_token(response)

    expires_at = decoded_jwt(token).first['exp']

    expires_at - Time.zone.now.to_i
  end

  def decoded_jwt(token)
    JWT.decode(token, nil, false, { algorithm: Siade.credentials[:cnous_jwt_hash_algo] })
  end

  def scope
    'VIEW_DOC,ETU_READ_STATUT'
  end

  def client_credentials_header
    Siade.credentials[:cnous_authenticate_credentials]
  end

  def client_url
    Siade.credentials[:cnous_authenticate_url]
  end
end
