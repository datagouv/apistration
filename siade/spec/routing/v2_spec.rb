RSpec.describe 'routes for v2', type: :routing do
  let!(:prefix_route) { 'v2/' }
  let!(:prefix_controller) { 'api/v2/' }

  describe 'INPI' do
    it 'route to actes' do
      expect(get("#{prefix_route}actes_inpi/#{valid_siren}"))
        .to route_to(controller: 'api/v2/documents_inpi', action: 'actes', siren: valid_siren)
    end

    it 'route to bilans' do
      expect(get("#{prefix_route}bilans_inpi/#{valid_siren}"))
        .to route_to(controller: 'api/v2/documents_inpi', action: 'bilans', siren: valid_siren)
    end
  end

  describe 'INSEE v3' do
    it 'route to etablissements' do
      expect(get("#{prefix_route}etablissements/#{valid_siret}"))
        .to route_to(controller: 'api/v2/etablissements_restored', action: 'show', siret: valid_siret)
    end

    it 'route to entreprises' do
      expect(get("#{prefix_route}entreprises/#{valid_siren}"))
        .to route_to(controller: 'api/v2/entreprises_restored', action: 'show', siren: valid_siren)
    end
  end

  it 'route to etablissements predecesseur' do
    expect(get("#{prefix_route}etablissements/#{valid_siret}/predecesseur"))
      .to route_to(controller: "#{prefix_controller}etablissements/predecesseur", action: 'show', siret: valid_siret)
  end

  it 'route to etablissements successeur' do
    expect(get("#{prefix_route}etablissements/#{valid_siret}/successeur"))
      .to route_to(controller: "#{prefix_controller}etablissements/successeur", action: 'show', siret: valid_siret)
  end

  it_behaves_like 'standard_siret_route', 'exercices'
  it_behaves_like 'standard_siret_route', 'cotisations_msa'
  it_behaves_like 'standard_siren_route', 'cartes_professionnelles_fntp'
  it_behaves_like 'standard_siren_route', 'certificats_opqibi'
  it_behaves_like 'standard_siret_route', 'certificats_agence_bio'

  describe 'liasse fiscale dgfip' do
    let(:annee) { '2015' }

    context 'new route' do
      it 'route to liasses fiscales dgfip complete' do
        expect(get("#{prefix_route}liasses_fiscales_dgfip/#{annee}/complete/#{valid_siren}"))
          .to route_to(controller: "#{prefix_controller}liasses_fiscales_dgfip", action: 'show', siren: valid_siren, annee: annee)
      end

      it 'route to liasses fiscales dgfip declarations' do
        expect(get("#{prefix_route}liasses_fiscales_dgfip/#{annee}/declarations/#{valid_siren}"))
          .to route_to(controller: "#{prefix_controller}liasses_fiscales_dgfip", action: 'declaration', siren: valid_siren, annee: annee)
      end

      it 'route to liasses fiscales dgfip dictionnaire' do
        expect(get("#{prefix_route}liasses_fiscales_dgfip/#{annee}/dictionnaire"))
          .to route_to(controller: "#{prefix_controller}liasses_fiscales_dgfip", action: 'dictionnaire', annee: annee)
      end
    end
  end

  it_behaves_like 'standard_siren_route', 'attestations_fiscales_dgfip'
  it_behaves_like 'standard_siren_route', 'attestations_sociales_acoss'
  it_behaves_like 'standard_siret_route', 'attestations_agefiph'
  it_behaves_like 'standard_siret_route', 'eligibilites_cotisation_retraite_probtp'
  it_behaves_like 'standard_siret_route', 'attestations_cotisation_retraite_probtp'
  it_behaves_like 'standard_siret_route', 'certificats_qualibat'
  it_behaves_like 'standard_siret_route', 'certificats_rge_ademe'
  it_behaves_like 'standard_siren_route', 'extraits_rcs_infogreffe'

  it 'route to associations' do
    expect(get("#{prefix_route}associations/#{valid_rna_id}"))
      .to route_to(controller: "#{prefix_controller}associations", action: 'show', id: valid_rna_id)
  end

  it 'route to documents_associations' do
    expect(get("#{prefix_route}documents_associations/#{valid_rna_id}"))
      .to route_to(controller: "#{prefix_controller}documents_associations", action: 'show', id: valid_rna_id)
  end

  it_behaves_like 'standard_siren_route', 'certificats_cnetp'
  it_behaves_like 'standard_siren_route', 'extraits_courts_inpi'
  it_behaves_like 'standard_siren_route', 'bilans_entreprises_bdf'

  it 'routes to conventions collectives' do
    expect(get("#{prefix_route}conventions_collectives/#{valid_siret}"))
      .to route_to(controller: "#{prefix_controller}conventions_collectives", action: 'show', siret: valid_siret)
  end

  it 'routes to entreprises artisabales' do
    expect(get("#{prefix_route}entreprises_artisanales_cma/#{valid_siren}"))
      .to route_to(controller: "#{prefix_controller}entreprises_artisanales", action: 'show', siren: valid_siren)
  end

  it 'route to eori_douanes' do
    expect(get("#{prefix_route}eori_douanes/#{valid_eori}"))
      .to route_to(controller: "#{prefix_controller}eori_douanes", action: 'show', siret_or_eori: valid_eori)
  end

  it 'route to privileges' do
    expect(get("#{prefix_route}privileges")).to route_to(controller: "#{prefix_controller}privileges", action: 'show')
  end

  it 'route to uptime#robot' do
    expect(get: '/v2/uptime?route=some/value')
      .to route_to(
        controller: 'api/v2/uptime',
        action: 'show',
        route: 'some/value'
      )
  end
end
