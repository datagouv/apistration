class FranceConnect::V2::DataFetcherThroughAccessToken::BuildClientAttributes < FranceConnect::BuildDataFromAccessTokenInteractor
  def call
    context.client_attributes = Resource.new(client_attributes)
  end

  private

  def client_attributes
    {
      client_id:,
      client_name: 'no_data_from_fc_v2'
    }
  end

  def client_id
    json_body['token_introspection']['aud']
  end
end
