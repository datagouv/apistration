require_relative '../provider_stubs'

module ProviderStubs::MSACotisations
  def mock_msa_cotisations(siret, status, allow_another_status: false)
    stub_request(:get, "#{Siade.credentials[:msa_conformites_cotisations_url]}/#{siret}").and_return(
      status: 200,
      body: msa_cotisations_payload(siret, status, allow_another_status:).to_json
    )
  end

  def msa_cotisations_payload(siret, status, allow_another_status: false)
    {
      'TopRMPResponse' => {
        'identifiantDebiteur' => siret,
        'topRegMarchePublic' => status_to_letter(status, allow_another_status)
      }
    }
  end

  def msa_gateway_timeout_payload
    {
      Erreur: {
        Code: 'soap:Server',
        Message: '504 Gateway Timeout'
      }
    }.to_json
  end

  def msa_bad_gateway_payload
    {
      Erreur: {
        Code: 'soap:Server',
        Message: '502 Bad Gateway'
      }
    }.to_json
  end

  private

  def status_to_letter(status, allow_another_status)
    case status
    when :up_to_date
      'O'
    when :outdated
      'N'
    when :under_investigation
      'A'
    when :unknown
      'S'
    else
      raise ArgumentError, 'Not valid status' unless allow_another_status

      status
    end
  end
end
