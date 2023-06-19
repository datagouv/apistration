require_relative '../provider_stubs'

module ProviderStubs::CNAFQuotientFamilialV2
  # rubocop:disable Metrics/MethodLength
  def stub_cnaf_quotient_familial_v2_valid(siret: valid_siret)
    stub_request(:get, Siade.credentials[:cnaf_quotient_familial_v2_url]).with(
      query: {
        codeLieuNaissance: '17300',
        codePaysNaissance: '99100',
        dateNaissance: '1980-06-12',
        genre: 'M',
        listePrenoms: 'JEAN-PASCAL',
        nomNaissance: 'CHAMPION',
        anneeDemandee: '2023',
        moisDemande: '12'
      },
      headers: {
        'Content-Type' => 'application/json',
        'Authorization' => 'Bearer super_valid_token',
        'X-APIPART-FSFINAL' => siret
      }
    ).to_return(
      status: 200,
      body: Rails.root.join('spec/fixtures/payloads/cnaf/quotient_familial_v2/make_request_valid.json').read
    )
  end
  # rubocop:enable Metrics/MethodLength

  def stub_cnaf_quotient_familial_v2_authenticate
    stub_request(:post, Siade.credentials[:cnaf_authenticate_url]).to_return(
      status: 200,
      body: Rails.root.join('spec/fixtures/payloads/cnaf/quotient_familial_v2/valid_authentication.json').read
    )
  end

  def stub_cnaf_quotient_familial_v2_404
    stub_request(:get, Siade.credentials[:cnaf_quotient_familial_v2_url]).with(
      query: hash_including({
        codePaysNaissance: '99623'
      })
    ).to_return(
      status: 404,
      body: Rails.root.join('spec/fixtures/payloads/cnaf/quotient_familial_v2/404.json').read
    )
  end
end
