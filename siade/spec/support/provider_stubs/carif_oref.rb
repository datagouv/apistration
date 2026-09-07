require_relative '../provider_stubs'

module ProviderStubs::CarifOref
  def stub_carif_oref_valid_siret(siret: valid_siret(:carif_oref))
    stub_request(:get, "#{Siade.credentials[:carif_oref_quiforme_url]}/organisme/#{siret}")
      .to_return(status: 200, body: read_payload_file('carif_oref/certifications_qualiopi_france_competences/valid_siret.json'))
  end

  def stub_carif_oref_no_data(siret: not_found_siret)
    stub_request(:get, "#{Siade.credentials[:carif_oref_quiforme_url]}/organisme/#{siret}")
      .to_return(status: 200, body: read_payload_file('carif_oref/certifications_qualiopi_france_competences/no_data.json'))
  end
end
