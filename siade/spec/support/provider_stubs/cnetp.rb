require_relative '../provider_stubs'

module ProviderStubs::CNETP
  def stub_cnetp_valid_siren(siren: valid_siren(:cnetp))
    stub_cnetp_request(siren:).to_return(
      status: 200,
      body: Rails.root.join('spec/fixtures/pdfs/cnetp_attestation_cotisations_conges_payes_chomage_intemperies/valid_siren.pdf').read,
      headers: { 'Content-Type' => 'application/pdf' }
    )
  end

  def stub_cnetp_not_found_siren(siren: not_found_siren)
    stub_cnetp_request(siren:).to_return(
      status: 404,
      body: "Le SIREN ou le SIRET n'est pas référencé dans nos fichiers".encode('ISO-8859-1'),
      headers: { 'Content-Type' => 'application/pdf;charset=ISO-8859-1' }
    )
  end

  private

  def stub_cnetp_request(siren:)
    stub_request(:get, "#{Siade.credentials[:cnetp_domain]}/webservice/doc/attestations/entreprises")
      .with(
        query: {
          id: Siade.credentials[:cnetp_client_number],
          jeton: Siade.credentials[:cnetp_token],
          siren:
        }
      )
  end
end
