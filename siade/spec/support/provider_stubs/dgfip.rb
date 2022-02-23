require_relative '../provider_stubs'

module ProviderStubs::DGFIP
  def mock_dgfip_authenticate
    stub_request(:post, Siade.credentials[:dgfip_authenticate_url]).and_return(
      status: 200,
      body: '',
      headers: {
        'Set-Cookie' => valid_dgfip_cookie
      }
    )
  end

  def mock_valid_dgfip_attestation_fiscale(siren, user_id, cookie = valid_dgfip_cookie, siren_is = nil, siren_tva = nil)
    stub_request(:get, Siade.credentials[:dgfip_attestations_fiscales_url]).with(
      headers: {
        'Cookie' => cookie,
        'Accept' => 'application/pdf'
      },
      query: build_dgfip_attestation_fiscale_query_params(siren, user_id)
    ).and_return(
      status: 200,
      body: extract_valid_dgfip_attestation_fiscale_pdf(siren_is, siren_tva)
    )
  end

  def mock_invalid_dgfip_attestation_fiscale(status)
    stub_request(:get, /^#{Siade.credentials[:dgfip_attestations_fiscales_url]}/).and_return(
      status: status
    )
  end

  private

  def extract_valid_dgfip_attestation_fiscale_pdf(siren_is, siren_tva)
    File.read(
      Rails.root.join(
        'spec/support/dgfip_attestations_fiscales',
        extract_valid_dgfip_attestation_fiscale_pdf_name(siren_is, siren_tva)
      )
    )
  end

  def build_dgfip_attestation_fiscale_query_params(siren, user_id)
    {
      siren: siren,
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
