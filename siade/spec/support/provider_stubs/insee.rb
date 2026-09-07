require_relative '../provider_stubs'

# rubocop:disable Metrics/ModuleLength
module ProviderStubs::INSEE
  def stub_insee_successions_make_request(siret:)
    stub_request(:get, query_url_succession(siret)).to_return(
      status: 200,
      body: open_payload_file('insee/succession_valid.json')
    )
  end

  def stub_insee_successions_not_found(siret:)
    stub_request(:get, query_url_succession(siret)).to_return(
      status: 404,
      body: open_payload_file('insee/succession_not_found.json')
    )
  end

  def stub_insee_authenticate
    stub_request(:post, Siade.credentials[:insee_oauth_url])
      .to_return(status: 200, body: { access_token: 'bearer_token', expires_in: 3600 }.to_json)
  end

  def stub_insee_metadonnees_one_result
    stub_request(:get, "#{Siade.credentials[:insee_metadata_url]}/geo/communes")
      .with(query: hash_including('filtreNom' => 'Gennevilliers'))
      .to_return(status: 200, body: read_payload_file('insee/metadonnees/one_result.json'))
  end

  def stub_insee_metadonnees_no_result
    stub_request(:get, "#{Siade.credentials[:insee_metadata_url]}/geo/communes")
      .with(query: hash_including('filtreNom' => 'invalid'))
      .to_return(status: 404, body: read_payload_file('insee/metadonnees/no_result.json'))
  end

  def stub_insee_metadonnees_multiple_results
    stub_request(:get, "#{Siade.credentials[:insee_metadata_url]}/geo/communes")
      .with(query: hash_including('filtreNom' => 'La Rochette'))
      .to_return(status: 200, body: read_payload_file('insee/metadonnees/multiple_results.json'))
  end

  def stub_insee_etablissement_active_ge
    stub_insee_siret_request(sirets_insee_v3[:active_GE], status: 200, payload: 'active_GE')
  end

  def stub_insee_etablissement_active_ge_ss
    stub_insee_siret_request(sirets_insee_v3[:active_GE_ss], status: 200, payload: 'active_GE_ss')
  end

  def stub_insee_etablissement_active_ae
    stub_insee_siret_request(sirets_insee_v3[:active_AE], status: 200, payload: 'active_AE')
  end

  def stub_insee_etablissement_closed
    stub_insee_siret_request(closed_siret, status: 200, payload: 'closed')
  end

  def stub_insee_etablissement_closed_without_date
    stub_insee_siret_request('78365263900015', status: 200, payload: 'closed_without_date')
  end

  def stub_insee_etablissement_non_diffusable
    stub_insee_siret_request(non_diffusable_siret, status: 200, payload: 'non_diffusable')
  end

  def stub_insee_etablissement_non_diffusable_ceased
    stub_insee_siret_request(confidential_siret(:non_diffusable_ceased), status: 403, payload: 'non_diffusable_ceased')
  end

  def stub_insee_etablissement_gendarmerie_limousin
    stub_insee_siret_request(confidential_siret(:gendarmerie_limousin), status: 403, payload: 'gendarmerie_limousin')
  end

  def stub_insee_etablissement_non_existent
    stub_insee_siret_request(non_existent_siret, status: 404, payload: 'non_existent')
  end

  # Special two-hop case: INSEE redirects a doublon siret (301 + Location) to the
  # siret of the etablissement siege, which #handle_redirect then re-requests.
  def stub_insee_etablissement_redirected
    stub_request(:get, insee_siret_url('53222169400013'))
      .to_return(status: 301, headers: { 'Location' => insee_siret_url('77887067500015') })

    stub_insee_siret_request('77887067500015', status: 200, payload: 'redirected')
  end

  def stub_insee_siege_active_ge
    stub_insee_siege_request(sirens_insee_v3[:active_GE], status: 200, payload: 'active_GE')
  end

  def stub_insee_siege_non_existent
    stub_insee_siege_request(non_existent_siren, status: 404, payload: 'non_existent')
  end

  def stub_insee_siege_non_diffusable_ceased
    stub_insee_siege_request(confidential_siren(:non_diffusable_ceased), status: 404, payload: 'non_diffusable_ceased')
  end

  def stub_insee_siege_non_diffusable
    stub_insee_siege_request(non_diffusable_siren, status: 200, payload: 'non_diffusable')
  end

  def stub_insee_siege_gendarmerie_limousin
    stub_insee_siege_request(confidential_siren(:gendarmerie_limousin), status: 404, payload: 'gendarmerie_limousin')
  end

  # Despite the "redirected" name (a historical/business label), this is a plain
  # 404, not an HTTP redirect: unlike INSEE::Etablissement::MakeRequest, this
  # endpoint's siren never triggers a 301 + Location hop.
  def stub_insee_siege_redirected
    stub_insee_siege_request('532221694', status: 404, payload: 'redirected')
  end

  def stub_insee_unite_legale_active_ge
    stub_insee_siren_request(sirens_insee_v3[:active_GE], status: 200, payload: 'active_GE')
  end

  def stub_insee_unite_legale_active_ae
    stub_insee_siren_request(sirens_insee_v3[:active_AE], status: 200, payload: 'active_AE')
  end

  def stub_insee_unite_legale_ceased
    stub_insee_siren_request(sirens_insee_v3[:ceased], status: 200, payload: 'ceased')
  end

  def stub_insee_unite_legale_non_existent
    stub_insee_siren_request(non_existent_siren, status: 404, payload: 'non_existent')
  end

  def stub_insee_unite_legale_non_diffusable_ceased
    stub_insee_siren_request(confidential_siren(:non_diffusable_ceased), status: 403, payload: 'non_diffusable_ceased')
  end

  def stub_insee_unite_legale_non_diffusable
    stub_insee_siren_request(non_diffusable_siren, status: 200, payload: 'non_diffusable')
  end

  def stub_insee_unite_legale_gendarmerie_limousin
    stub_insee_siren_request(confidential_siren(:gendarmerie_limousin), status: 403, payload: 'gendarmerie_limousin')
  end

  # Special two-hop case: INSEE redirects a siren (301 + Location) to another
  # siren, which #handle_redirect then re-requests.
  def stub_insee_unite_legale_redirected
    stub_request(:get, insee_siren_url('532221694'))
      .to_return(status: 301, headers: { 'Location' => insee_siren_url('778870675') })

    stub_insee_siren_request('778870675', status: 200, payload: 'redirected')
  end

  private

  def stub_insee_siret_request(siret, status:, payload:)
    stub_request(:get, insee_siret_url(siret))
      .to_return(status:, body: read_payload_file("insee/siret/#{payload}.json"))
  end

  def stub_insee_siege_request(siren, status:, payload:)
    stub_request(:get, "#{Siade.credentials[:insee_sirene_url]}/api-sirene/prive/3.11/siret")
      .with(query: hash_including('q' => "etablissementSiege:true AND siren:#{siren}"))
      .to_return(status:, body: read_payload_file("insee/siege/#{payload}.json"))
  end

  def stub_insee_siren_request(siren, status:, payload:)
    stub_request(:get, insee_siren_url(siren))
      .to_return(status:, body: read_payload_file("insee/siren/#{payload}.json"))
  end

  def insee_siret_url(siret)
    "#{Siade.credentials[:insee_sirene_url]}/api-sirene/prive/3.11/siret/#{siret}"
  end

  def insee_siren_url(siren)
    "#{Siade.credentials[:insee_sirene_url]}/api-sirene/prive/3.11/siren/#{siren}"
  end

  def query_url_succession(siret)
    "#{Siade.credentials[:insee_sirene_url]}/api-sirene/prive/3.11/siret/liensSuccession?#{query_params_succession(siret)}"
  end

  def query_params_succession(siret)
    "q=siretEtablissementSuccesseur:#{siret} OR siretEtablissementPredecesseur:#{siret}"
  end
end
# rubocop:enable Metrics/ModuleLength
