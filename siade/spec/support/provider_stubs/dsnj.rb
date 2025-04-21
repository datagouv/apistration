require_relative '../provider_stubs'

module ProviderStubs::DSNJ
  def stub_dsnj_service_national_valid
    stub_request(:post, Siade.credentials[:dsnj_service_national_url]).to_return(
      status: 200,
      body: read_payload_file('dsnj/service_national/found.json')
    )
  end

  def stub_dsnj_service_national_not_found
    stub_request(:post, Siade.credentials[:dsnj_service_national_url]).to_return(
      status: 200,
      body: read_payload_file('dsnj/service_national/not_found.json')
    )
  end
end
