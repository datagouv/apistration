require_relative '../../provider_stubs'
require_relative '../inpi'

module ProviderStubs::INPI::RNE
  def stub_inpi_rne_authenticate(token: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJleHAiOjE3MzU1ODg4MDB9.test')
    stub_request(:post, Siade.credentials[:inpi_rne_login_url])
      .to_return(status: 200, body: { 'token' => token }.to_json, headers: { 'Content-Type' => 'application/json' })
  end

  def stub_inpi_rne_actes_bilans_valid(siren: valid_siren(:inpi))
    stub_request(:get, "#{Siade.credentials[:inpi_rne_url]}/api/companies/#{siren}/attachments")
      .to_return(
        status: 200,
        body: read_payload_file('inpi/rne/actes_bilans/valid.json')
      )
  end

  def stub_inpi_rne_download_valid(target:, document_id:)
    stub_request(:get, "#{Siade.credentials[:inpi_rne_url]}/api/#{target}/#{document_id}/download")
      .to_return(
        status: 200,
        body: read_payload_file('pdf/dummy.pdf'),
        headers: { 'Content-Type' => 'application/pdf' }
      )
  end

  def stub_inpi_rne_download_not_found(target:, document_id:)
    stub_request(:get, "#{Siade.credentials[:inpi_rne_url]}/api/#{target}/#{document_id}/download")
      .to_return(
        status: 404
      )
  end

  def stub_inpi_rne_extrait_download_valid(document_id:)
    stub_request(:get, "https://data.inpi.fr/export/companies?format=pdf&ids=[\"#{document_id}\"]")
      .to_return(
        status: 200,
        body: read_payload_file('pdf/dummy.pdf'),
        headers: { 'Content-Type' => 'application/pdf' }
      )
  end
end
