require_relative '../provider_stubs'

module ProviderStubs::CNOUSAuthenticate
  def mock_cnous_authenticate
    stub_request(:post, Siade.credentials[:cnous_authenticate_url]).to_return(
      status: 200,
      headers: { Authorization: "Bearer #{build_jwt_bearer}" }
    )
  end

  private

  def build_jwt_bearer
    JWT.encode(payload_jwt_cnous, OpenSSL::PKey::RSA.new(512), Siade.credentials[:cnous_jwt_hash_algo])
  end

  def payload_jwt_cnous
    {
      exp: 2_661_444_052,
      admin: false,
      view_doc: true,
      sub: '178',
      iss: 'api.lescrous.fr',
      env: 'PRD',
      appId: '59b17725ae575a4530ab6bbaafeb8eadd754',
      roles: 'VIEW_DOC,ETU_READ_STATUT'
    }
  end
end
