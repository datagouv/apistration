RSpec.describe GIPMDS::ServiceCivique, type: :retriever_organizer do
  subject { described_class.call(params:) }

  shared_examples 'an impossible case, since a person does one service civique only and none after an ended one' do
    it 'does not pick a contract: answers a provider error (502), reported to Sentry at error level with an explicit message' do
      expect(subject).to be_a_failure
      expect(subject.errors.first).to be_an_instance_of(ProviderUnknownError)
      expect(subject.errors.first.tracking_level).to eq('error')
      expect(subject.errors.first.detail).to include("une personne ne peut effectuer qu'un seul service civique")
    end
  end

  let(:params) do
    {
      nom_naissance: 'Dupont',
      prenoms: %w[Jean Paul],
      annee_date_naissance: 1990,
      mois_date_naissance: 6,
      jour_date_naissance: 25
    }
  end

  let(:dade_url) { "#{Siade.credentials[:gip_mds_domain]}/api-fraude/1.0.0/api/dade/generique" }
  let(:provider_status) { 200 }
  let(:provider_body) { read_payload_file('gip_mds/service_civique/valid.json') }

  let!(:dade_request) do
    stub_request(:get, dade_url)
      .with(
        query: {
          nom: 'DUPONT',
          prenom: 'Jean',
          dateNaissance: '25061990',
          listeCodeNature: '89',
          comparaisonCertifiee: '1',
          dateDebutPeriode: '2021-06-15'
        },
        headers: { 'Authorization' => 'Bearer dade_token' }
      )
      .and_return(status: provider_status, body: provider_body)
  end

  let(:resource) { subject.bundled_data.data }

  before do
    Timecop.freeze(Time.zone.local(2026, 6, 15, 10, 30, 0))

    stub_request(:post, "#{Siade.credentials[:gip_mds_domain]}/token")
      .with(body: hash_including(client_id: Siade.credentials[:gip_mds_dade_client_id]))
      .and_return(status: 200, body: { access_token: 'dade_token', expires_in: 3600 }.to_json)

    stub_request(:post, "#{Siade.credentials[:gip_mds_domain]}/token")
      .with(body: hash_including(client_id: Siade.credentials[:gip_mds_client_id]))
      .and_return(status: 200, body: { access_token: 'effectifs_token', expires_in: 3600 }.to_json)

    GIPMDS::Authenticate.call
  end

  after do
    Timecop.return
  end

  it 'asks the DADe web service, with the DADe client token, for the missions active during the last 5 years' do
    subject

    expect(dade_request).to have_been_requested
  end

  context 'when the only contract has no end date: the mission is ongoing' do
    it 'returns the host organisation and an ongoing mission, without end date' do
      expect(resource.organisme_accueil).to eq(siret: '34442248200013')
      expect(resource.dates).to eq(debut: '2025-12-01', fin: nil, en_cours: true)
    end
  end

  context 'when the only contract ended normally: the mission is over' do
    let(:provider_body) { read_payload_file('gip_mds/service_civique/past_contract.json') }

    it 'returns its actual end date and a mission no longer ongoing' do
      expect(resource.dates).to eq(debut: '2023-01-15', fin: '2023-07-14', en_cours: false)
    end
  end

  describe 'a contract closed with motif 99 (cancellation): the declared end was cancelled, the mission goes on under the same contract' do
    context 'when it is the only contract' do
      let(:provider_body) { read_payload_file('gip_mds/service_civique/valid_motif_rupture_99.json') }

      it 'returns an ongoing mission, without the cancelled end date' do
        expect(resource.dates).to eq(debut: '2024-01-15', fin: nil, en_cours: true)
      end
    end

    context 'when an older, unrelated mission ended normally next to it' do
      let(:provider_body) { read_payload_file('gip_mds/service_civique/motif_rupture_99_and_older_mission.json') }

      it_behaves_like 'an impossible case, since a person does one service civique only and none after an ended one'
    end
  end

  describe 'a contract closed with motif 100 (transfer): the volunteer moved to another establishment, the mission goes on under a new contract' do
    context 'when the new contract, starting after it, is in the response' do
      let(:provider_body) { read_payload_file('gip_mds/service_civique/mutation.json') }

      it 'drops the closed contract and returns the new one, with its host organisation, as the ongoing mission' do
        expect(resource.organisme_accueil).to eq(siret: '77567227221138')
        expect(resource.dates).to eq(debut: '2026-01-01', fin: nil, en_cours: true)
      end
    end

    context 'when the new contract is not in the response yet' do
      let(:provider_body) { read_payload_file('gip_mds/service_civique/valid_motif_rupture_100.json') }

      it 'returns the closed contract as an ongoing mission, without its end date' do
        expect(resource.dates).to eq(debut: '2024-01-15', fin: nil, en_cours: true)
      end
    end

    context 'when the new contract is not in the response yet, and an older mission ended normally next to it: the older one is never taken for the new contract' do
      let(:provider_body) { read_payload_file('gip_mds/service_civique/mutation_and_older_mission.json') }

      it_behaves_like 'an impossible case, since a person does one service civique only and none after an ended one'
    end
  end

  context 'when the person is known but has no service civique contract over the last 5 years' do
    let(:provider_body) { read_payload_file('gip_mds/service_civique/no_contract.json') }

    it 'answers not found (404)' do
      expect(subject).to be_a_failure
      expect(subject.errors).to include(instance_of(NotFoundError))
    end
  end

  {
    'NOT_FOUND_INDIVIDU' => 'not_found.json',
    'NOT_FOUND_CONTRAT' => 'not_found_contrat.json'
  }.each do |provider_code, fixture|
    context "when the web service finds nothing (#{provider_code})" do
      let(:provider_status) { 404 }
      let(:provider_body) { read_payload_file("gip_mds/service_civique/#{fixture}") }

      it 'answers not found (404)' do
        expect(subject).to be_a_failure
        expect(subject.errors).to include(instance_of(NotFoundError))
      end
    end
  end

  context 'when an ongoing mission and an older ended one are both declared' do
    let(:provider_body) { read_payload_file('gip_mds/service_civique/multiple_contracts.json') }

    it_behaves_like 'an impossible case, since a person does one service civique only and none after an ended one'
  end

  context 'when the web service answers an unexpected error whose message echoes the requested identity' do
    let(:provider_status) { 501 }
    let(:provider_body) { read_payload_file('gip_mds/service_civique/appel_ko_with_identity.json') }

    it 'answers a provider error (502) and reports the DADe body to Sentry encrypted, never the identity in clear' do
      expect(subject).to be_a_failure
      reported_body = subject.errors.first.monitoring_private_context[:http_response_body]

      expect(reported_body).to start_with('-----BEGIN PGP MESSAGE-----')
      expect(reported_body).not_to include('DUPONT', '25061990')
    end
  end

  context 'when the web service hits its contract limit (206 OK_PARTIEL): the list of contracts is incomplete' do
    let(:provider_status) { 206 }
    let(:provider_body) { read_payload_file('gip_mds/service_civique/partial.json') }

    it 'answers a provider error (502), since the retained contract could be the wrong one' do
      expect(subject).to be_a_failure
      expect(subject.errors).to include(instance_of(ProviderUnknownError))
    end
  end
end
