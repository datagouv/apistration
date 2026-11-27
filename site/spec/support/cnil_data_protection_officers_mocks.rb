module CnilDataProtectionOfficersMocks
  def stub_cnil_data_protection_officers(designations = [])
    stub_request(:get, /\A#{Regexp.escape(CnilDataProtectionOfficersClient::DATA_URL)}/).to_return(
      status: 200,
      headers: { 'Content-Type' => 'application/json' },
      body: { data: designations }.to_json
    )
  end
end
