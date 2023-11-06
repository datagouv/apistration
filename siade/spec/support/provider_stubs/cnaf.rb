require_relative '../provider_stubs'

module ProviderStubs::CNAF
  # rubocop:disable Metrics/MethodLength
  def stub_cnaf_valid(api, siret: valid_siret)
    stub_request(:get, cnaf_url(api)).with(
      query: hash_including({
        codeLieuNaissance: '17300',
        codePaysNaissance: '99100',
        dateNaissance: '1980-06-12',
        genre: 'M',
        listePrenoms: 'JEAN-PASCAL',
        nomNaissance: 'CHAMPION'
      }),
      headers: {
        'Content-Type' => 'application/json',
        'Authorization' => 'Bearer super_valid_token',
        'X-APIPART-FSFINAL' => siret
      }
    ).to_return(
      status: 200,
      body: Rails.root.join("spec/fixtures/payloads/cnaf/#{api}/make_request_valid.json").read,
      headers: {
        'X-APISECU-FD' => '00810011'
      }
    )
  end
  # rubocop:enable Metrics/MethodLength

  def stub_cnaf_authenticate(api)
    stub_request(:post, Siade.credentials[:cnaf_authenticate_url]).with(
      headers: {
        'Authorization' => "Basic #{Base64.urlsafe_encode64("#{cnaf_client_id(api)}:#{cnaf_secret_id(api)}")}"
      }
    ).to_return(
      status: 200,
      body: Rails.root.join("spec/fixtures/payloads/cnaf/#{api}/valid_authentication.json").read
    )
  end

  def stub_cnaf_404(api)
    stub_request(:get, cnaf_url(api)).with(
      query: hash_including({})
    ).to_return(
      status: 404,
      headers: {
        'X-APISECU-FD' => '00171001'
      },
      body: Rails.root.join("spec/fixtures/payloads/cnaf/#{api}/404.json").read
    )
  end

  def cnaf_client_id(api)
    Siade.credentials["cnaf_#{api}_client_id".to_sym]
  end

  def cnaf_secret_id(api)
    Siade.credentials["cnaf_#{api}_client_secret".to_sym]
  end

  def cnaf_url(api)
    Siade.credentials["cnaf_#{api}_url".to_sym]
  end
end
