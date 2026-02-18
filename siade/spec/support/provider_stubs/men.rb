require_relative '../provider_stubs'

module ProviderStubs::MEN
  def stub_men_scolarites_auth
    stub_request(:post, Siade.credentials[:men_scolarites_authenticate_url]).to_return(
      status: 200,
      body: open_payload_file('men/scolarites/authenticate.json')
    )
  end

  def stub_men_scolarites_valid
    stub_request(:get, /#{Siade.credentials[:men_scolarites_url_v1]}/).to_return(
      status: 200,
      body: open_payload_file('men/scolarites/valid.json')
    )
  end

  def stub_men_scolarites_ping
    stub_request(:get, Siade.credentials[:men_scolarites_ping_url]).with(
      headers: {
        'Authorization' => 'Bearer jwt-access-token'
      }
    ).to_return(
      status: 200,
      body: nil
    )
  end

  def stub_men_scolarites_not_found
    stub_request(:get, /#{Siade.credentials[:men_scolarites_url_v1]}/).to_return(
      status: 404,
      body: open_payload_file('men/scolarites/not_found.json')
    )
  end

  def stub_men_scolarites_perimetre_valid
    stub_request(:post, "#{Siade.credentials[:men_scolarites_url_v2]}/perimetre").to_return(
      status: 200,
      body: open_payload_file('men/scolarites/valid_v2_with_bourse.json')
    )
  end

  def stub_men_scolarites_perimetre_not_found
    stub_request(:post, "#{Siade.credentials[:men_scolarites_url_v2]}/perimetre").to_return(
      status: 404,
      body: open_payload_file('men/scolarites/not_found.json')
    )
  end
end
