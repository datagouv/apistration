require_relative '../provider_stubs'

module ProviderStubs::INSEE
  def stub_insee_succession_make_request(siret:)
    stub_request(:get, query_url_succession(siret)).to_return(
      status: 200,
      body: open_payload_file('insee/succession_valid.json')
    )
  end

  private

  def query_url_succession(siret)
    "#{Siade.credentials[:insee_v3_domain]}/entreprises/sirene/V3.11/siret/liensSuccession?#{query_params_succession(siret)}"
  end

  def query_params_succession(siret)
    "q=siretEtablissementSuccesseur:#{siret} OR siretEtablissementPredecesseur:#{siret}"
  end
end
