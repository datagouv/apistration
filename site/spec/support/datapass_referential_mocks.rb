module DatapassReferentialMocks
  DATAPASS_API_URL = 'https://datapass.example.test/api/v1'.freeze

  def stub_datapass_referential(particulier_forms: datapass_fixture('formulaires_api_particulier'), particulier_definition: datapass_fixture('definition_api_particulier'))
    stub_credential(:datapass_api, url: DATAPASS_API_URL, client_id: 'datapass_client_id', client_secret: 'datapass_client_secret')
    stub_request(:post, "#{DATAPASS_API_URL}/oauth/token")
      .to_return(status: 200, headers: datapass_json_headers, body: { access_token: 'token', token_type: 'Bearer', expires_in: 7200 }.to_json)
    stub_datapass_definition('api_entreprise', forms: [], definition: { 'scopes' => [] })
    stub_datapass_definition('api_particulier', forms: particulier_forms, definition: particulier_definition)
  end

  def stub_datapass_definition(definition_id, forms:, definition:)
    stub_request(:get, "#{DATAPASS_API_URL}/definitions/#{definition_id}/formulaires")
      .to_return(status: 200, headers: datapass_json_headers, body: forms.to_json)
    stub_request(:get, "#{DATAPASS_API_URL}/definitions/#{definition_id}")
      .to_return(status: 200, headers: datapass_json_headers, body: definition.to_json)
  end

  def stub_datapass_unavailable(definition_id)
    stub_request(:get, %r{#{DATAPASS_API_URL}/definitions/#{definition_id}})
      .to_return(status: 404, headers: datapass_json_headers, body: { error: 'Not Found' }.to_json)
  end

  def datapass_fixture(name)
    JSON.parse(Rails.root.join("spec/fixtures/datapass_api/#{name}.json").read)
  end

  private

  def datapass_json_headers
    { 'Content-Type' => 'application/json' }
  end
end
