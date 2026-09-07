require_relative '../provider_stubs'

module ProviderStubs::FranceTravail
  def stub_france_travail_authenticate
    stub_request(:post, Siade.credentials[:france_travail_authenticate_url])
      .to_return(
        status: 200,
        body: {
          access_token: 'france_travail_access_token',
          token_type: 'Bearer',
          expires_in: 1499
        }.to_json
      )
  end

  def stub_france_travail_indemnites_valid(identifiant:)
    stub_request(:get, "#{Siade.credentials[:france_travail_indemnites_url]}?loginMnemotechnique=#{identifiant}")
      .to_return(
        status: 200,
        body: read_payload_file('france_travail/indemnites/valid.json')
      )
  end

  def stub_france_travail_indemnites_not_found(identifiant:)
    stub_request(:get, "#{Siade.credentials[:france_travail_indemnites_url]}?loginMnemotechnique=#{identifiant}")
      .to_return(
        status: 404
      )
  end

  def stub_france_travail_statut_valid
    stub_request(:post, Siade.credentials[:france_travail_status_url])
      .to_return(
        status: 200,
        body: read_payload_file('france_travail/statut/valid.json')
      )
  end

  def stub_france_travail_statut_not_found
    stub_request(:post, Siade.credentials[:france_travail_status_url])
      .to_return(
        status: 404,
        body: read_payload_file('france_travail/statut/not_found.json')
      )
  end
end
