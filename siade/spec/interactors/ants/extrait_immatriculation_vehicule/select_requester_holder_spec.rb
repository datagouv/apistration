RSpec.describe ANTS::ExtraitImmatriculationVehicule::SelectRequesterHolder, type: :validate_response do
  subject { described_class.call(response:, params:, provider_name: 'ANTS') }

  let(:response) { instance_double(Net::HTTPOK, code: '200', body: body.to_json) }
  let(:params) { { nom_naissance: 'Dupont', prenoms: %w[Jean], annee_date_naissance: 1980, mois_date_naissance: 4, jour_date_naissance: 12 } }

  let(:body) do
    payload = JSON.parse(read_payload_file('ants/found.json'))
    payload['listeDossiers'][0]['personne']['qualiteType'] = qualites
    payload
  end

  let(:titulaire) do
    {
      'code' => 'TIT',
      'libelle' => 'Titulaire',
      'identite' => {
        'estPhysique' => true,
        'nomNaiss' => 'DUPONT',
        'prenom' => 'JEAN',
        'naissance' => { 'date' => '1980-04-12' }
      },
      'adresse' => {}
    }
  end

  let(:cotitulaire) do
    {
      'code' => 'COT',
      'libelle' => 'Cotitulaire',
      'identite' => { 'estPhysique' => true, 'nomNaiss' => 'MARTIN', 'prenom' => 'PAUL' },
      'adresse' => {}
    }
  end

  let(:personne_morale) do
    {
      'code' => 'TIT',
      'libelle' => 'Titulaire',
      'identite' => { 'estPhysique' => false, 'nomNaiss' => nil, 'prenom' => nil, 'raisonSociale' => 'ACME' },
      'adresse' => {}
    }
  end

  context 'when the requester is the only holder' do
    let(:qualites) { [titulaire] }

    it { is_expected.to be_a_success }

    its(:holder) { is_expected.to eq(titulaire) }

    its(:matches) { is_expected.to be(true) }

    its(:matchings) { is_expected.to include('matchbirthdate' => true) }
  end

  context 'when the birth date differs but the names match' do
    let(:params) { { nom_naissance: 'Dupont', prenoms: %w[Jean], annee_date_naissance: 1990, mois_date_naissance: 1, jour_date_naissance: 1 } }
    let(:qualites) { [titulaire] }

    its(:holder) { is_expected.to eq(titulaire) }

    its(:matchings) { is_expected.to include('matchbirthdate' => false) }
  end

  context 'when another holder is listed before the requester' do
    let(:qualites) { [cotitulaire, titulaire] }

    its(:holder) { is_expected.to eq(titulaire) }
  end

  context 'when a legal entity is listed before the requester' do
    let(:qualites) { [personne_morale, titulaire] }

    its(:holder) { is_expected.to eq(titulaire) }
  end

  context 'when no holder is the requester' do
    let(:qualites) { [cotitulaire] }

    it { is_expected.to be_a_failure }

    its(:errors) { is_expected.to include(instance_of(ANTSError)) }
  end

  context 'when there is no holder at all' do
    let(:qualites) { [] }

    it { is_expected.to be_a_failure }

    its(:errors) { is_expected.to include(instance_of(ANTSError)) }
  end
end
