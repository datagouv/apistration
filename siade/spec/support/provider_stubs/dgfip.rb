require_relative '../provider_stubs'

module ProviderStubs::DGFIP
  def mock_dgfip_authenticate
    stub_request(:post, "#{Siade.credentials[:dgfip_apim_base_url]}/token")
      .to_return(status: 200, body: { access_token: 'bearer_token' }.to_json)
  end

  def mock_valid_dgfip_attestation_fiscale(siren, siren_is = nil, siren_tva = nil)
    mock_dgfip_authenticate

    stub_request(:get, %r{#{Siade.credentials[:dgfip_apim_base_url]}/adelie/v1/attestationFiscale.*siren=#{siren}}).to_return(
      status: 200,
      body: extract_valid_dgfip_attestation_fiscale_pdf(siren_is, siren_tva)
    )
  end

  def mock_invalid_dgfip_attestation_fiscale(status)
    stub_request(:get, %r{^#{Siade.credentials[:dgfip_apim_base_url]}/adelie/v1/attestationFiscale}).and_return(
      status:
    )
  end

  def extract_dgfip_liasses_fiscales_payload(name)
    JSON.parse(
      Rails.root.join(
          "spec/fixtures/payloads/dgfip/liasses_fiscales/#{name}.json"
        ).read
    )
  end

  def mock_valid_dgfip_chiffres_affaires(siret)
    mock_dgfip_authenticate

    stub_request(:get, %r{#{Siade.credentials[:dgfip_apim_base_url]}/adelie/v1/chiffreAffaire.*siret=#{siret}}).to_return(
      status: 200,
      body: read_payload_file('dgfip/chiffre_affaires/valid.json')
    )
  end

  def mock_invalid_dgfip_chiffres_affaires(status)
    mock_dgfip_authenticate

    stub_request(:get, %r{#{Siade.credentials[:dgfip_apim_base_url]}/adelie/v1/chiffreAffaire}).to_return(
      status:
    )
  end

  def mock_valid_dgfip_liasse_fiscale(siren, year, payload_name = 'obligation_fiscale_simplified')
    mock_dgfip_authenticate

    mock_valid_dgfip_dictionnaire(year)

    stub_request(:get, %r{#{Siade.credentials[:dgfip_apim_base_url]}/adelie/v1/getLiasseFiscale\?annee=#{year}.*siren=#{siren}}).to_return(
      status: 200,
      body: read_payload_file("dgfip/liasses_fiscales/#{payload_name}.json")
    )
  end

  def mock_invalid_dgfip_liasse_fiscale(status)
    mock_dgfip_authenticate

    stub_request(:get, %r{#{Siade.credentials[:dgfip_apim_base_url]}/adelie/v1/getLiasseFiscale}).to_return(
      status:
    )
  end

  def mock_valid_dgfip_dictionnaire(year)
    mock_dgfip_authenticate

    stub_request(:get, %r{#{Siade.credentials[:dgfip_apim_base_url]}/adelie/v1/dictionnaire\?annee=#{year}}).to_return(
      status: 200,
      body: read_payload_file('dgfip/dictionary.json')
    )
  end

  private

  def extract_valid_dgfip_attestation_fiscale_pdf(siren_is = nil, siren_tva = nil)
    Rails.root.join(
      'spec/fixtures/pdfs/dgfip_attestations_fiscales',
      extract_valid_dgfip_attestation_fiscale_pdf_name(siren_is, siren_tva)
    ).read
  end

  def build_dgfip_attestation_fiscale_query_params(siren, user_id)
    {
      siren:,
      groupeIS: 'NON',
      groupeTVA: 'NON',
      userId: user_id
    }
  end

  def extract_valid_dgfip_attestation_fiscale_pdf_name(siren_is, siren_tva)
    if siren_is.nil? && siren_tva.nil?
      'basic.pdf'
    elsif siren_is.nil?
      'tva.pdf'
    elsif siren_tva.nil?
      'is.pdf'
    else
      'is_and_tva.pdf'
    end
  end
end
