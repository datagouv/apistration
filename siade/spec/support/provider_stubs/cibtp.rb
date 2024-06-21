require_relative '../provider_stubs'

module ProviderStubs::CIBTP
  def stub_cibtp_authenticate
    stub_request(:post, "#{Siade.credentials[:cibtp_domain]}/apiEntreprise/token")
      .to_return(
        status: 200,
        body: {
          token_type: 'Bearer',
          expires_in: 3599,
          ext_expires_in: 3599,
          access_token: 'super_cibtp_access_token'
        }.to_json
      )
  end
end
