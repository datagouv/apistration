require_relative '../provider_stubs'

module ProviderStubs::CNOUSAuthenticate
  def mock_cnous_student_scholarship_civility_valid_call
    stub_request(:post, /#{Siade.credentials[:cnous_student_scholarship_civility_url]}/).to_return(
      status: 200,
      body: File.read(Rails.root.join('spec/fixtures/payloads/cnous_student_scholarship_valid_response.json'))
    )
  end

  def mock_cnous_student_scholarship_ine_valid_call
    stub_request(:get, /#{Siade.credentials[:cnous_student_scholarship_ine_url]}/).to_return(
      status: 200,
      body: File.read(Rails.root.join('spec/fixtures/payloads/cnous_student_scholarship_valid_response.json'))
    )
  end

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
      exp: 2.hours.from_now.to_i,
      admin: false,
      view_doc: true,
      sub: '178',
      iss: 'api.lescrous.fr',
      env: 'PRD',
      appId: 'dummy app_id',
      roles: 'VIEW_DOC,ETU_READ_STATUT'
    }
  end
end
