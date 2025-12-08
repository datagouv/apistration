require_relative '../provider_stubs'

module ProviderStubs::CNOUSStudentScholarship
  def mock_cnous_valid_call(endpoint)
    method = endpoint == 'civility' ? :post : :get

    stub_request(method, /#{cnous_url_for(endpoint)}/).to_return(
      status: 200,
      body: cnous_valid_payload(endpoint).to_json
    )
  end

  def mock_cnous_not_found_call(endpoint)
    method = endpoint == 'civility' ? :post : :get

    stub_request(method, /#{cnous_url_for(endpoint)}/).to_return(
      status: 404,
      body: cnous_not_found_payload(endpoint).to_json
    )
  end

  def cnous_not_found_payload(endpoint)
    valid_json_entry = JSON.parse(read_payload_file('cnous/student_scholarship_not_found.json'))

    endpoint == 'civility' ? [valid_json_entry] : valid_json_entry
  end

  def cnous_valid_payload(endpoint)
    valid_json_entry = JSON.parse(read_payload_file('cnous/student_scholarship_valid_response.json'))

    endpoint == 'civility' ? [valid_json_entry] : valid_json_entry
  end

  def cnous_url_for(kind)
    Siade.credentials[:"cnous_student_scholarship_#{kind}_url"]
  end

  def mock_cnous_authenticate
    stub_request(:post, Siade.credentials[:cnous_authenticate_url]).to_return(
      status: 200,
      body: { access_token: 'test_cnous_token', expires_in: 7200 }.to_json,
      headers: { 'Content-Type' => 'application/json' }
    )
  end
end
