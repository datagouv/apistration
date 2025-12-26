require_relative '../provider_stubs'

# rubocop:disable Metrics/ModuleLength
module ProviderStubs::GIPMDS
  def mock_gip_mds_authenticate
    stub_request(:post, "#{Siade.credentials[:gip_mds_domain]}/token").and_return(
      status: 200,
      body: {
        access_token: 'access_token',
        expires_in: 3600,
        token_type: 'Bearer'
      }.to_json
    )
  end

  def mock_gip_mds_not_found
    stub_request(:get, %r{#{Siade.credentials[:gip_mds_domain]}/rcd-api/1.0.0/effectifs}).and_return(
      status: 404
    )
  end

  # rubocop:disable Metrics/MethodLength
  def mock_gip_mds_annuel_effectifs(siren:, year:, body: nil)
    stub_request(:get, "#{Siade.credentials[:gip_mds_domain]}/rcd-api/1.0.0/effectifs").with(
      query: {
        codeOPSDemandeur: '00000DINUM',
        dateHeure: Time.zone.now.iso8601,
        source: 'RA;RG',
        nature: 'A01',
        siren:,
        periode: "#{year}1231"
      },
      headers: {
        'Content-Type' => 'application/json',
        'Authorization' => 'Bearer access_token'
      }
    ).and_return(
      status: 200,
      body: body || gip_mds_stubbed_payload_for_annuel(siren:, year:).to_json
    )
  end

  def mock_gip_mds_mensuel_effectifs(siret:, year:, month:, depth: nil, body: nil)
    stub_request(:get, "#{Siade.credentials[:gip_mds_domain]}/rcd-api/1.0.0/effectifs").with(
      query: {
        codeOPSDemandeur: '00000DINUM',
        dateHeure: Time.zone.now.iso8601,
        source: 'RA;RG',
        nature: 'M01',
        siret:,
        profondeurHistorique: depth,
        periode: "#{year}#{month}01"
      }.compact,
      headers: {
        'Content-Type' => 'application/json',
        'Authorization' => 'Bearer access_token'
      }
    ).and_return(
      status: 200,
      body: body || gip_mds_stubbed_payload_for_mensuel(siret:, year:, month:).to_json
    )
  end

  def gip_mds_stubbed_payload_for_annuel(siren:, year:, nature: 'A01', regime_agricole_effectifs: '12.34', regime_general_effectifs: '56.78')
    [
      build_gip_mds_effectif_payload(
        effectifs: regime_agricole_effectifs
      ).merge(
        siren:,
        periode: "#{year}1231",
        nature:,
        source: 'RA'
      ),
      build_gip_mds_effectif_payload(
        effectifs: regime_general_effectifs
      ).merge(
        siren:,
        nature:,
        periode: "#{year}1231",
        source: 'RG'
      )
    ]
  end

  # rubocop:disable Metrics/ParameterLists
  def gip_mds_stubbed_payload_for_mensuel(siret:, year:, month:, nature: 'M01', regime_agricole_effectifs: '12.34', regime_general_effectifs: '56.78')
    [
      build_gip_mds_effectif_payload(
        effectifs: regime_agricole_effectifs
      ).merge(
        siret:,
        periode: "#{year}#{month}01",
        nature:,
        source: 'RA'
      ),
      build_gip_mds_effectif_payload(
        effectifs: regime_general_effectifs
      ).merge(
        siret:,
        nature:,
        periode: "#{year}#{month}01",
        source: 'RG'
      )
    ]
  end
  # rubocop:enable Metrics/ParameterLists
  # rubocop:enable Metrics/MethodLength

  def build_gip_mds_effectif_payload(effectifs:, updated_at: nil)
    if effectifs
      {
        effectifs:,
        miseAJourRCD: (updated_at || Time.zone.now).strftime('%Y-%m-%d')
      }
    else
      {
        effectifs: 'NC'
      }
    end
  end

  def stub_gip_mds_service_civique_valid
    mock_gip_mds_authenticate
    stub_request(:get, %r{#{Siade.credentials[:gip_mds_domain]}/contrats-generique}).and_return(
      status: 200,
      body: read_payload_file('gip_mds/service_civique/valid.json')
    )
  end

  def stub_gip_mds_service_civique_not_found
    mock_gip_mds_authenticate
    stub_request(:get, %r{#{Siade.credentials[:gip_mds_domain]}/contrats-generique}).and_return(
      status: 404,
      body: read_payload_file('gip_mds/service_civique/not_found.json')
    )
  end
end
# rubocop:enable Metrics/ModuleLength
