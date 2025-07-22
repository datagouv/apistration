require_relative '../provider_stubs'

module ProviderStubs::ANTS
  def stub_ants_dossier_immatriculation_valid
    # stub_request(:post, Siade.credentials[:ants_dossier_immatriculation_url]).to_return(
    #   status: 200,
    #   body: read_payload_file('ants/dossier_immatriculation/found.json')
    # )
  end

  def stub_ants_dossier_immatriculation_not_found
    # stub_request(:post, Siade.credentials[:ants_dossier_immatriculation_url]).to_return(
    #   status: 200,
    #   body: read_payload_file('ants/dossier_immatriculation/not_found.json')
    # )
  end
end
