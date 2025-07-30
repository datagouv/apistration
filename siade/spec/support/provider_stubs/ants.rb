require_relative '../provider_stubs'

module ProviderStubs::ANTS
  def stub_ants_extrait_immatriculation_vehicule_valid
    # stub_request(:post, Siade.credentials[:ants_extrait_immatriculation_vehicule_url]).to_return(
    #   status: 200,
    #   body: read_payload_file('ants/extrait_immatriculation_vehicule/found.json')
    # )
  end

  def stub_ants_extrait_immatriculation_vehicule_not_found
    # stub_request(:post, Siade.credentials[:ants_extrait_immatriculation_vehicule_url]).to_return(
    #   status: 200,
    #   body: read_payload_file('ants/extrait_immatriculation_vehicule/not_found.json')
    # )
  end
end
