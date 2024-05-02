class FranceConnect::DataFetcherThroughAccessToken::BuildServiceUserIdentity < FranceConnect::BuildDataFromAccessTokenInteractor
  def call
    context.service_user_identity = Resource.new(normalized_identity)
  end

  private

  def origin_identity
    json_body['identity']
  end

  def normalized_identity
    origin_identity.tap do |identity|
      next if identity.key?('preferred_username')

      identity['preferred_username'] = nil
    end
  end
end
