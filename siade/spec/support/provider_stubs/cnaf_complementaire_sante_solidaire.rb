require_relative '../provider_stubs'

module ProviderStubs::CNAFComplementaireSanteSolidaire
  # rubocop:disable Metrics/MethodLength
  def stub_cnaf_complementaire_sante_solidaire_valid(siret: valid_siret)
    stub_request(:get, Siade.credentials[:cnaf_complementaire_sante_solidaire_url]).with(
      query: {
        codeLieuNaissance: '17300',
        codePaysNaissance: '99100',
        dateNaissance: '1980-06-12',
        genre: 'M',
        listePrenoms: 'JEAN-PASCAL',
        nomNaissance: 'CHAMPION'
      },
      headers: {
        'Content-Type' => 'application/json',
        'Authorization' => 'Bearer super_valid_token',
        'X-APIPART-FSFINAL' => siret
      }
    ).to_return(
      status: 200,
      body: Rails.root.join('spec/fixtures/payloads/cnaf/complementaire_sante_solidaire/make_request_valid.json').read,
      headers: {
        'X-APISECU-FD' => '00810011'
      }
    )
  end
  # rubocop:enable Metrics/MethodLength

  def stub_cnaf_complementaire_sante_solidaire_authenticate
    stub_request(:post, Siade.credentials[:cnaf_authenticate_url]).to_return(
      status: 200,
      body: Rails.root.join('spec/fixtures/payloads/cnaf/complementaire_sante_solidaire/valid_authentication.json').read
    )
  end

  def stub_cnaf_complementaire_sante_solidaire_404
    stub_request(:get, Siade.credentials[:cnaf_complementaire_sante_solidaire_url]).with(
      query: hash_including({
        codePaysNaissance: '99623'
      })
    ).to_return(
      status: 404,
      body: Rails.root.join('spec/fixtures/payloads/cnaf/complementaire_sante_solidaire/404.json').read
    )
  end
end
