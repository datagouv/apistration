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

  def stub_cibtp_attestations_marche_public_valid(siret:)
    stub_request(:get, "#{Siade.credentials[:cibtp_domain]}/apiEntreprise/attestationMarche")
      .with(query: { siret: })
      .to_return(
        status: 200,
        body: read_payload_file('pdf/dummy.pdf'),
        headers: { 'Content-Type' => 'application/pdf' }
      )
  end

  def stub_cibtp_attestations_marche_public_conflict(siret:)
    stub_request(:get, "#{Siade.credentials[:cibtp_domain]}/apiEntreprise/attestationMarche")
      .with(query: { siret: })
      .to_return(
        status: 409,
        body: {
          type: 'Fonctionnelle',
          message: "Conflict - L'entreprise est connue du réseau mais nous sommes dans l'impossibilité de fournir une attestation (exemple:changement de caisse)"
        }.to_json
      )
  end
end
