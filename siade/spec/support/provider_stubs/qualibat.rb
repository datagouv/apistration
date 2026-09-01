require_relative '../provider_stubs'

module ProviderStubs::QUALIBAT
  def stub_qualibat_authenticate
    stub_request(:post, "#{Siade.credentials[:qualibat_api_url]}/token")
      .to_return(
        status: 200,
        body: {
          access_token: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiJhbm9ueW1pemVkX3F1YWxpYmF0X3VzZXIiLCJleHAiOjE2ODgwNDE0NTJ9.anonymized_qualibat_jwt_signature_fake_token_for_testing',
          token_type: 'bearer',
          expires_in: 1800.0
        }.to_json
      )
  end

  def stub_qualibat_valid_siret(siret: valid_siret(:qualibat))
    stub_request(:get, "#{Siade.credentials[:qualibat_api_url]}/certificat/#{siret}")
      .to_return(
        status: 200,
        body: read_payload_file('qualibat/certifications_batiment/valid_siret.pdf'),
        headers: { 'Content-Type' => 'application/pdf' }
      )
  end

  def stub_qualibat_not_found_siret(siret: not_found_siret(:qualibat))
    stub_request(:get, "#{Siade.credentials[:qualibat_api_url]}/certificat/#{siret}")
      .to_return(
        status: 200,
        body: read_payload_file('qualibat/certifications_batiment/not_found_siret.json')
      )
  end
end
