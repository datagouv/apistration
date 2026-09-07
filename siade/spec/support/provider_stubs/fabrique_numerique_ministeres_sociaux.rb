require_relative '../provider_stubs'

module ProviderStubs::FabriqueNumeriqueMinisteresSociaux
  def stub_fabrique_numerique_conventions_collectives_valid(siret: valid_siret(:conventions_collectives))
    stub_request(:get, "#{Siade.credentials[:fabrique_numerique_conventions_collectives_url]}/#{siret}")
      .to_return(status: 200, body: read_payload_file('fabrique_numerique_ministeres_sociaux/conventions_collectives/valid_siret.json'))
  end

  def stub_fabrique_numerique_conventions_collectives_not_found(siret: not_found_siret(:conventions_collectives))
    stub_request(:get, "#{Siade.credentials[:fabrique_numerique_conventions_collectives_url]}/#{siret}")
      .to_return(status: 200, body: read_payload_file('fabrique_numerique_ministeres_sociaux/conventions_collectives/not_found_siret.json'))
  end
end
