RSpec.describe FormulaireQFAPIClient do
  subject(:client) { described_class.new }

  let(:host) { 'https://formulaire-qf.example.com' }
  let(:secret) { 'formulaire-qf-secret' }
  let(:organization) { create(:organization) }

  before do
    stub_credential(:formulaire_qf, host:, secret:)
    allow(organization).to receive_messages(
      code_commune_etablissement: '75056',
      code_postal_etablissement: '75001',
      denomination: 'Ma Collectivité'
    )
  end

  describe '#create_collectivity' do
    before do
      stub_request(:post, "#{host}/api/collectivites")
        .with(headers: { 'Authorization' => "Bearer #{secret}" })
        .to_return(status: 201)
    end

    it 'posts the collectivity to FormulaireQF' do
      client.create_collectivity(organization:, editor_id: 'EDITOR1')

      expect(WebMock).to have_requested(:post, "#{host}/api/collectivites").with(
        body: {
          siret: organization.siret,
          code_cog: '75056',
          departement: '75',
          name: 'Ma Collectivité',
          status: 'active',
          editor: 'EDITOR1'
        }.to_json
      )
    end
  end

  describe '#find_collectivity' do
    before do
      stub_request(:get, "#{host}/api/collectivites/75056")
        .with(headers: { 'Authorization' => "Bearer #{secret}" })
        .to_return(status: 200, headers: { 'Content-Type' => 'application/json' }, body: { 'id' => 1 }.to_json)
    end

    it 'returns the parsed collectivity' do
      expect(client.find_collectivity(organization:)).to eq('id' => 1)
    end
  end

  describe '#collectivities' do
    before do
      stub_request(:get, "#{host}/api/collectivites")
        .with(headers: { 'Authorization' => "Bearer #{secret}" })
        .to_return(status: 200, headers: { 'Content-Type' => 'application/json' }, body: [{ 'id' => 1 }].to_json)
    end

    it 'returns the parsed list' do
      expect(client.collectivities).to eq([{ 'id' => 1 }])
    end
  end
end
