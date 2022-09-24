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
      status:
    )
  end

  def mock_valid_dgfip_svair
    mock_dgfip_svair_view_state

    stub_request(:post, 'https://cfsmsp.impots.gouv.fr/secavis/faces/commun/index.jsf').to_return(
      status: 200,
      body: Rails.root.join('spec/fixtures/payloads/dgfip/svair/valid_response_one_declarant.html').read
    )
  end

  def mock_not_found_dgfip_svair
    mock_dgfip_svair_view_state

    stub_request(:post, 'https://cfsmsp.impots.gouv.fr/secavis/faces/commun/index.jsf').to_return(
      status: 200,
      body: Rails.root.join('spec/fixtures/payloads/dgfip/svair/not_found.html').read
    )
  end

  def mock_dgfip_svair_view_state(payload: nil)
    payload ||= '<input type="hidden" name="javax.faces.ViewState" value="view_state_value" />'

    stub_request(:get, 'https://cfsmsp.impots.gouv.fr/secavis/').to_return(
      status: 200,
      body: payload
    )
  end

  def extract_dgfip_liasses_fiscales_payload(name)
    JSON.parse(
      Rails.root.join(
          "spec/fixtures/payloads/dgfip/liasses_fiscales/#{name}.json"
        ).read
    )
  end

  private

  def extract_valid_dgfip_attestation_fiscale_pdf(siren_is, siren_tva)
    Rails.root.join(
      'spec/support/dgfip_attestations_fiscales',
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
