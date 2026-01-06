require_relative '../provider_stubs'

# rubocop:disable Metrics/ModuleLength
module ProviderStubs::CNAV
  # rubocop:disable Metrics/MethodLength
  def stub_cnav_valid(api, siret: valid_siret, extra_params: {})
    stub_request(:get, cnav_url(api)).with(
      query: hash_including({
        codeLieuNaissance: '17300',
        codePaysNaissance: '99100',
        dateNaissance: '1980-06-12',
        genre: 'M',
        listePrenoms: 'JEAN-PASCAL',
        nomNaissance: 'CHAMPION'
      }.merge(extra_params)),
      headers: {
        'Content-Type' => 'application/json',
        'Authorization' => 'Bearer super_valid_token',
        'X-APIPART-FSFINAL' => siret
      }
    ).to_return(
      status: 200,
      body: read_payload_file("cnav/#{api}/make_request_valid.json"),
      headers: {
        'X-APISECU-FD' => '00810011'
      }
    )
  end

  def stub_cnav_valid_with_transcogage(api, siret: valid_siret, extra_params: {})
    stub_request(:get, cnav_url(api)).with(
      query: hash_including({
        nomNaissance: 'CHAMPION',
        listePrenoms: 'JEAN-PASCAL',
        dateNaissance: '1980-06-12',
        genre: 'M',
        codePaysNaissance: '99100',
        villeNaissance: 'LA ROCHELLE',
        depNaissance: '17'
      }.merge(extra_params)),
      headers: {
        'Content-Type' => 'application/json',
        'Authorization' => 'Bearer super_valid_token',
        'X-APIPART-FSFINAL' => siret
      }
    ).to_return(
      status: 200,
      body: read_payload_file("cnav/#{api}/make_request_valid.json"),
      headers: {
        'X-APISECU-FD' => '00810011'
      }
    )
  end

  def stub_cnav_valid_with_franceconnect_data(api, siret: valid_siret)
    stub_request(:get, cnav_url(api)).with(
      query: hash_including({
        codeLieuNaissance: '75101',
        codePaysNaissance: '99100',
        dateNaissance: france_connect_default_birthdate,
        genre: 'M',
        listePrenoms: 'Jean Martin',
        nomNaissance: 'DUPONT'
      }),
      headers: {
        'Content-Type' => 'application/json',
        'X-APIPART-FSFINAL' => siret
      }
    ).to_return(
      status: 200,
      body: read_payload_file("cnav/#{api}/make_request_valid.json"),
      headers: {
        'X-APISECU-FD' => '00810011'
      }
    )
  end

  def france_connect_default_birthdate
    "#{Time.zone.today.year - 20}-01-01"
  end
  # rubocop:enable Metrics/MethodLength

  def stub_cnav_authenticate(api)
    stub_request(:post, Siade.credentials[:cnav_authenticate_url]).with(
      headers: {
        'Authorization' => "Basic #{Base64.urlsafe_encode64("#{cnav_client_id(api)}:#{cnav_secret_id(api)}")}"
      }
    ).to_return(
      status: 200,
      body: read_payload_file('cnav/valid_authentication.json')
    )
  end

  def stub_cnav_404(api, provider_label = nil)
    stub_request(:get, cnav_url(api)).with(
      query: hash_including({})
    ).to_return(
      status: 404,
      headers: {
        'X-APISECU-FD' => CNAV::RetrieverOrganizer::REGIME_CODE_FROM_LABEL[provider_label] || nil
      },
      body: read_payload_file("cnav/#{api}/404.json")
    )
  end

  def stub_sngi_404(api)
    stub_request(:get, cnav_url(api)).with(
      query: hash_including({})
    ).to_return(
      status: 404,
      headers: {},
      body: read_payload_file('cnav/404-identity-not-found.json')
    )
  end

  def stub_rncps_404(api)
    stub_request(:get, cnav_url(api)).with(
      query: hash_including({})
    ).to_return(
      status: 404,
      headers: {},
      body: read_payload_file('cnav/404-regime-not-found.json')
    )
  end

  def cnav_client_id(api)
    Siade.credentials[:"cnav_#{api}_client_id"]
  end

  def cnav_secret_id(api)
    Siade.credentials[:"cnav_#{api}_client_secret"]
  end

  def cnav_url(api)
    Siade.credentials[:"cnav_#{api}_url"]
  end
end
# rubocop:enable Metrics/ModuleLength
