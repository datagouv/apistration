# frozen_string_literal: true

RSpec.describe SimplifionsStore, type: :store do
  let(:grist_base) { 'https://grist.numerique.gouv.fr/api/docs/ofSVjCSAnMb6/tables' }
  let(:sitemap_url) { 'https://simplifions.data.gouv.fr/sitemap.xml' }

  let(:apis_response) do
    {
      'records' => [
        { 'id' => 1, 'fields' => { 'UID_datagouv' => '672cf982fcc8065be6e66f54', 'Nom' => 'API Quotient familial' } },
        { 'id' => 2, 'fields' => { 'UID_datagouv' => 'uid-not-declared-in-rails', 'Nom' => 'API non mappée Rails' } }
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
        {
          'id' => 11,
          'fields' => {
            'Visible_sur_simplifions' => false,
            'Nom' => 'Cas non visible'
          }
        },
        {
          'id' => 12,
          'fields' => {
            'Visible_sur_simplifions' => true,
            'Nom' => 'Cas visible sans fiche Rails',
            'Description_courte' => 'Visible via la solution.',
            'Icone_du_titre' => nil,
            'A_destination_de' => ['L'],
            'Pour_simplifier_les_demarches_de' => ['L']
          }
        }
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
        },
        {
          'id' => 2,
          'fields' => {
            'Solution_fournisseur' => 1,
            'API_ou_dataset_fourni' => 2,
            'Utile_pour_les_cas_d_usages' => ['L', 12]
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

  let(:sitemap_response) do
    <<~XML
      <?xml version="1.0" encoding="UTF-8"?>
      <urlset xmlns="http://www.sitemaps.org/schemas/sitemap/0.9">
        <url><loc>https://simplifions.data.gouv.fr/cas-d-usages/tarification-cantine-scolaire-a-1eur</loc></url>
        <url><loc>https://simplifions.data.gouv.fr/cas-d-usages/cas-visible-sans-fiche-rails</loc></url>
      </urlset>
    XML
  end

  before do
    stub_request(:get, "#{grist_base}/APIs_et_datasets/records").to_return(body: apis_response)
    stub_request(:get, "#{grist_base}/Cas_d_usages/records").to_return(body: cas_usages_response)
    stub_request(:get, "#{grist_base}/API_et_datasets_fournis/records").to_return(body: fournis_response)
    stub_request(:get, "#{grist_base}/Fournisseurs_de_services/records").to_return(body: fournisseurs_response)
    stub_request(:get, "#{grist_base}/Usagers/records").to_return(body: usagers_response)
    stub_request(:get, sitemap_url).to_return(body: sitemap_response)

    described_class.instance.reset!
  end

  describe '#for_endpoint' do
    subject(:cas_usages) { described_class.instance.for_endpoint('cnav/quotient_familial', api: 'api_particulier') }

    it 'returns simplifions cas usages for a known endpoint' do
      expect(cas_usages).to contain_exactly(
        have_attributes(
          name: 'Tarification cantine scolaire à 1€',
          url: 'https://simplifions.data.gouv.fr/cas-d-usages/tarification-cantine-scolaire-a-1eur',
          description: 'Calculez le tarif automatiquement.',
          icon: '🏫',
          administrations: ['Communes et groupements de communes'],
          public_cible: ['Entreprises']
        )
      )
    end

    it 'excludes cas usages not visible on simplifions' do
      expect(cas_usages.map(&:name)).not_to include('Cas non visible')
    end

    it 'returns an empty array for unknown endpoint' do
      expect(described_class.instance.for_endpoint('unknown/endpoint', api: 'api_entreprise')).to eq([])
    end
  end

  describe '#all' do
    subject(:cas_usages) { described_class.instance.all(api: 'api_particulier') }

    it 'returns all visible cas usages for the api solution' do
      expect(cas_usages.map(&:name)).to contain_exactly(
        'Cas visible sans fiche Rails',
        'Tarification cantine scolaire à 1€'
      )
    end

    it 'does not require a Rails endpoint mapping' do
      expect(cas_usages.map(&:name)).to include('Cas visible sans fiche Rails')
    end

    it 'returns an empty array for unknown api' do
      expect(described_class.instance.all(api: 'api_entreprise')).to eq([])
    end
  end

  describe 'when a visible cas usage has no name' do
    let(:cas_usages_response) do
      {
        'records' => [
          { 'id' => 10, 'fields' => { 'Visible_sur_simplifions' => true, 'Nom' => 'Avec nom' } },
          { 'id' => 12, 'fields' => { 'Visible_sur_simplifions' => true, 'Nom' => nil } }
        ]
      }.to_json
    end

    before { described_class.instance.reset! }

    it 'sorts without raising on the nil name' do
      expect { described_class.instance.all(api: 'api_particulier') }.not_to raise_error
    end
  end

  describe 'when Grist is unavailable' do
    before do
      stub_request(:get, "#{grist_base}/APIs_et_datasets/records").to_raise(Faraday::Error)
      described_class.instance.reset!
    end

    it 'returns an empty array gracefully' do
      expect(described_class.instance.for_endpoint('cnav/quotient_familial', api: 'api_particulier')).to eq([])
    end
  end
end
