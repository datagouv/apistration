require_relative '../provider_stubs'

module ProviderStubs::PROBTP
  def stub_probtp_attestation_eligible(siret: eligible_siret(:probtp))
    stub_probtp_attestation_request(siret, body: read_payload_file('probtp/attestation/with_eligible_siret.json'))
  end

  def stub_probtp_attestation_not_found(siret: not_found_siret(:probtp))
    stub_probtp_attestation_request(siret, body: read_payload_file('probtp/attestation/with_not_found_siret.json'))
  end

  def stub_probtp_conformite_eligible(siret: eligible_siret(:probtp))
    stub_probtp_conformite_request(siret, body: read_payload_file('probtp/conformites_cotisations_retraite/with_eligible_siret.json'))
  end

  def stub_probtp_conformite_non_eligible(siret: non_eligible_siret(:probtp))
    stub_probtp_conformite_request(siret, body: read_payload_file('probtp/conformites_cotisations_retraite/with_non_eligible_siret.json'))
  end

  def stub_probtp_conformite_not_found(siret: not_found_siret(:probtp))
    stub_probtp_conformite_request(siret, body: read_payload_file('probtp/conformites_cotisations_retraite/with_not_found_siret.json'))
  end

  private

  def stub_probtp_attestation_request(siret, body:)
    stub_request(:post, "#{Siade.credentials[:probtp_domain]}/ws_ext/rest/certauth/mpsservices/getAttestationCotisation")
      .with(body: { corps: siret }.to_json)
      .to_return(status: 200, body:)
  end

  def stub_probtp_conformite_request(siret, body:)
    stub_request(:post, "#{Siade.credentials[:probtp_domain]}/ws_ext/rest/certauth/mpsservices/getStatutCotisation")
      .with(body: { corps: siret }.to_json)
      .to_return(status: 200, body:)
  end
end
