require_relative '../provider_stubs'

module ProviderStubs::Qualifelec
  def stub_qualifelec_auth_success(token: qualifelec_jwt_bearer)
    stub_request(:post, Siade.credentials[:qualifelec_auth_url]).to_return({
      status: 200,
      body: {
        token:
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

  def stub_qualifelec_certificates(siret: valid_siret(:qualifelec))
    stub_request(:get, "#{Siade.credentials[:qualifelec_certificates_url]}/#{siret}").to_return(
      status: 200,
      body: read_payload_file('qualifelec/valid_siret_with_certificates.json')
    )
  end

  def stub_qualifelec_404(siret: not_found_siret)
    stub_request(:get, "#{Siade.credentials[:qualifelec_certificates_url]}/#{siret}").to_return(
      status: 404,
      body: read_payload_file('qualifelec/404.json')
    )
  end

  def stub_qualifelec_no_certificates(siret: not_found_siret)
    stub_request(:get, "#{Siade.credentials[:qualifelec_certificates_url]}/#{siret}").to_return(
      status: 200,
      body: '[]'
    )
  end

  def qualifelec_jwt_bearer
    @qualifelec_jwt_bearer ||= build_qualifelec_jwt_bearer
  end

  def build_qualifelec_jwt_bearer
    rsa_private = OpenSSL::PKey::RSA.generate 2048

    JWT.encode payload_jwt_qualifelec, rsa_private, 'RS256'
  end

  def payload_jwt_qualifelec
    {
      exp: 1.hour.from_now.to_i,
      roles: %w[ROLE_API],
      username: 'api',
      iat: Time.zone.now.to_i
    }
  end
end
