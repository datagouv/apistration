class FranceConnect::DataFetcherThroughAccessToken::BuildServiceUserIdentity < FranceConnect::DataFetcherThroughAccessToken::BuildDataFromAccessTokenInteractor
  def call
    context.service_user_identity = Resource.new(identity)
  end

  private

  def identity
    {
      gender: token_introspection['gender'],
      family_name: token_introspection['family_name'],
      given_name: token_introspection['given_name'],
      given_name_array: token_introspection['given_name_array'],
      birthdate: token_introspection['birthdate'],
      birthplace: token_introspection['birthplace'],
      birthcountry: token_introspection['birthcountry'],
      preferred_username: nil
    }
  end

  def token_introspection
    json_body['token_introspection']
  end
end
