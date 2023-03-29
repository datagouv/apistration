require_relative '../provider_stubs'

module ProviderStubs::INSEE
  def mock_insee_partially_diffusible_unite_legale_personne_morale
    stub_request(:get, "#{Siade.credentials[:insee_v3_domain]}/entreprises/sirene/V3/siren/#{sirens_insee_v3_mock[:partially_diffusible_unite_legale_personne_morale]}")
      .and_return(
        status: 200,
        body: Rails.root.join('spec/fixtures/payloads/insee/partially_diffusible_unite_legale_personne_morale.json').read
      )
  end

  def mock_insee_partially_diffusible_unite_legale_personne_physique
    stub_request(:get, "#{Siade.credentials[:insee_v3_domain]}/entreprises/sirene/V3/siren/#{sirens_insee_v3_mock[:partially_diffusible_unite_legale_personne_physique]}")
      .and_return(
        status: 200,
        body: Rails.root.join('spec/fixtures/payloads/insee/partially_diffusible_unite_legale_personne_physique.json').read
      )
  end
end
