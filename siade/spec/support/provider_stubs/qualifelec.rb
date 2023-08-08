require_relative '../provider_stubs'

module ProviderStubs::Qualifelec
  def stub_qualifelec_auth_success
    stub_request(:post, Siade.credentials[:qualifelec_auth_url]).to_return({
      status: 200,
      body: {
        token: 'SUPER TOKEN'
      }.to_json,
      headers: {}
    })
  end

  def stub_qualifelec_auth_failure
    stub_request(:post, Siade.credentials[:qualifelec_auth_url]).to_return({
      status: 401,
      body: {
        code: 401,
        message: 'JWT Token not found'
      }.to_json,
      headers: {}
    })
  end

  def stub_qualifelec_certificates(siret: valid_siret(:qualifelec), token: 'SUPER TOKEN')
    stub_request(:get, "#{Siade.credentials[:qualifelec_certificates_url]}/#{siret}").with(
      headers: {
        'Authorization' => "Bearer #{token}"
      }
    ).to_return(
      status: 200,
      body: read_payload_file('qualifelec/valid_siret_with_certificates.json')
    )
  end

  def stub_qualifelec_404(siret: not_found_siret, token: 'SUPER TOKEN')
    stub_request(:get, "#{Siade.credentials[:qualifelec_certificates_url]}/#{siret}").with(
      headers: {
        'Authorization' => "Bearer #{token}"
      }
    ).to_return(
      status: 404,
      body: read_payload_file('qualifelec/404.json')
    )
  end
end
