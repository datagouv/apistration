require_relative '../provider_stubs'

module ProviderStubs::Infogreffe
  def stub_infogreffe_personne_morale
    stub_request(:post, /#{Siade.credentials[:infogreffe_url_extrait_rcs]}/).to_return(
      status: 200,
      body: read_payload_file('infogreffe/personne_morale.xml')
    )
  end

  def stub_infogreffe_personne_physique
    stub_request(:post, /#{Siade.credentials[:infogreffe_url_extrait_rcs]}/).to_return(
      status: 200,
      body: read_payload_file('infogreffe/personne_physique.xml')
    )
  end

  def stub_infogreffe_siren_not_found
    stub_request(:post, /#{Siade.credentials[:infogreffe_url_extrait_rcs]}/).to_return(
      status: 200,
      body: read_payload_file('infogreffe/siren_not_found.xml')
    )
  end

  def stub_infogreffe_no_greffe_code
    stub_request(:post, /#{Siade.credentials[:infogreffe_url_extrait_rcs]}/).to_return(
      status: 200,
      body: read_payload_file('infogreffe/no_greffe_code.xml')
    )
  end
end
