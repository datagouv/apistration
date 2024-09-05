require_relative '../provider_stubs'

module ProviderStubs::FranceTravail
  def stub_france_travail_indemnites_valid(identifiant:)
    stub_request(:get, "#{Siade.credentials[:pole_emploi_indemnites_url]}?loginMnemotechnique=#{identifiant}")
      .to_return(
        status: 200,
        body: read_payload_file('pole_emploi/indemnites/valid.json')
      )
  end

  def stub_france_travail_indemnites_no_content(identifiant:)
    stub_request(:get, "#{Siade.credentials[:pole_emploi_indemnites_url]}?loginMnemotechnique=#{identifiant}")
      .to_return(
        status: 204
      )
  end

  def stub_france_travail_statut_valid
    stub_request(:post, Siade.credentials[:pole_emploi_status_url])
      .to_return(
        status: 200,
        body: read_payload_file('pole_emploi/statut/valid.json')
      )
  end

  def stub_france_travail_statut_not_found
    stub_request(:post, Siade.credentials[:pole_emploi_status_url])
      .to_return(
        status: 404,
        body: read_payload_file('pole_emploi/statut/not_found.json')
      )
  end
end
