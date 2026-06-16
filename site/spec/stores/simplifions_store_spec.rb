# frozen_string_literal: true

RSpec.describe SimplifionsStore, type: :store do
  let(:grist_base) { 'https://grist.numerique.gouv.fr/api/docs/ofSVjCSAnMb6/tables' }

  let(:apis_response) do
    {
      'records' => [
        { 'id' => 1, 'fields' => { 'UID_datagouv' => '672cf982fcc8065be6e66f54', 'Nom' => 'API Quotient familial' } }
      ]
    }.to_json
  end

  let(:cas_usages_response) do
    {
      'records' => [
        {
          'id' => 10,
          'fields' => {
            'Visible_sur_simplifions' => true,
            'Nom' => 'Tarification cantine scolaire à 1€',
            'Description_courte' => 'Calculez le tarif automatiquement.',
            'Icone_du_titre' => '🏫',
            'A_destination_de' => ['L', 1],
            'Pour_simplifier_les_demarches_de' => ['L', 2]
          }
        },
        { 'id' => 11, 'fields' => { 'Visible_sur_simplifions' => false, 'Nom' => 'Cas non visible' } }
      ]
    }.to_json
  end

  let(:fournis_response) do
    {
      'records' => [
        {
          'id' => 1,
          'fields' => {
            'Solution_fournisseur' => 1,
            'API_ou_dataset_fourni' => 1,
            'Utile_pour_les_cas_d_usages' => ['L', 10, 11]
          }
        }
      ]
    }.to_json
  end

  let(:fournisseurs_response) do
    { 'records' => [{ 'id' => 1, 'fields' => { 'Label' => 'Communes et groupements de communes' } }] }.to_json
  end

  let(:usagers_response) do
    { 'records' => [{ 'id' => 2, 'fields' => { 'Label' => 'Entreprises' } }] }.to_json
  end

  before do
    stub_request(:get, "#{grist_base}/APIs_et_datasets/records").to_return(body: apis_response)
    stub_request(:get, "#{grist_base}/Cas_d_usages/records").to_return(body: cas_usages_response)
    stub_request(:get, "#{grist_base}/API_et_datasets_fournis/records").to_return(body: fournis_response)
    stub_request(:get, "#{grist_base}/Fournisseurs_de_services/records").to_return(body: fournisseurs_response)
    stub_request(:get, "#{grist_base}/Usagers/records").to_return(body: usagers_response)

    allow(described_class).to receive(:load_uid_mapping).and_return(
      'api_particulier' => { '672cf982fcc8065be6e66f54' => ['cnav/quotient_familial'] }
    )

    described_class.reset_cache!
  end

  describe '.links_for' do
    subject { described_class.links_for('cnav/quotient_familial', api: 'api_particulier') }

    it 'returns simplifions links for a known endpoint' do
      expect(subject).to contain_exactly(
        hash_including(
          name: 'Tarification cantine scolaire à 1€',
          url: 'https://simplifions.data.gouv.fr/cas-d-usages/tarification-cantine-scolaire-a-1',
          description: 'Calculez le tarif automatiquement.',
          icon: '🏫',
          administrations: ['Communes et groupements de communes'],
          public_cible: ['Entreprises']
        )
      )
    end

    it 'excludes cas_usages not visible on simplifions' do
      expect(subject.map { |l| l[:name] }).not_to include('Cas non visible')
    end

    context 'with unknown endpoint' do
      subject { described_class.links_for('unknown/endpoint', api: 'api_entreprise') }

      it { is_expected.to eq([]) }
    end
  end

  describe '.all_use_cases' do
    subject { described_class.all_use_cases(api: 'api_particulier') }

    it 'returns all visible cas_usages for the api solution' do
      expect(subject).to contain_exactly(
        hash_including(name: 'Tarification cantine scolaire à 1€')
      )
    end

    it 'excludes cas_usages not visible on simplifions' do
      expect(subject.map { |l| l[:name] }).not_to include('Cas non visible')
    end

    it 'returns empty array for unknown api' do
      expect(described_class.all_use_cases(api: 'api_entreprise')).to eq([])
    end
  end

  describe 'when Grist is unavailable' do
    before do
      stub_request(:get, "#{grist_base}/APIs_et_datasets/records").to_raise(Faraday::Error)
      described_class.reset_cache!
    end

    it 'returns an empty hash gracefully' do
      expect(described_class.links_for('cnav/quotient_familial', api: 'api_particulier')).to eq([])
    end
  end
end
