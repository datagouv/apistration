require_relative '../provider_stubs'

module ProviderStubs::ADEME
  def stub_ademe_valid_siret(siret: valid_siret(:rge_ademe))
    stub_request(:get, Siade.credentials[:ademe_rge_url])
      .with(query: hash_including('qs' => "siret:#{siret} AND traitement_termine:false", 'size' => '1000'))
      .to_return(status: 200, body: read_payload_file('ademe/certificats_rge/valid_siret.json'))
  end

  def stub_ademe_valid_siret_with_limit(siret: valid_siret(:rge_ademe), limit: 2)
    stub_request(:get, Siade.credentials[:ademe_rge_url])
      .with(query: hash_including('qs' => "siret:#{siret} AND traitement_termine:false", 'size' => limit.to_s))
      .to_return(status: 200, body: read_payload_file('ademe/certificats_rge/valid_siret_with_limit.json'))
  end

  def stub_ademe_not_found_siret(siret: not_found_siret(:rge_ademe))
    stub_request(:get, Siade.credentials[:ademe_rge_url])
      .with(query: hash_including('qs' => "siret:#{siret} AND traitement_termine:false", 'size' => '1000'))
      .to_return(status: 200, body: read_payload_file('ademe/certificats_rge/not_found_siret.json'))
  end
end
