RSpec.describe EditorDelegationRequest::Import do
  subject(:result) { described_class.call(editor_use_case:, rows:) }

  let(:editor_use_case) { create(:editor_use_case) }
  let!(:already_imported) { create(:editor_delegation_request, editor_use_case:, siret: '21030190500018', contact_email: 'mairie@exemple.fr') }
  let(:rows) do
    [
      { 'siret' => '21340172201787', 'contact_email' => ' achats@saint-exemple.fr ' },
      { 'siret' => '213 401 722 01795', 'contact_email' => nil },
      { 'siret' => '213401722', 'contact_email' => 'siren@exemple.fr' },
      { 'siret' => '21340172201787', 'contact_email' => 'doublon@exemple.fr' },
      { 'siret' => already_imported.siret, 'contact_email' => 'autre@exemple.fr' }
    ]
  end

  before do
    stub_datapass_formulaires
    allow(UpdateOrganizationINSEEPayloadJob).to receive(:perform_later)
  end

  it 'creates one delegation request per valid and new SIRET' do
    expect { result }.to change(EditorDelegationRequest, :count).by(2)

    expect(result.created.map(&:siret)).to contain_exactly('21340172201787', '21340172201795')
    expect(result.created.map(&:contact_email)).to contain_exactly('achats@saint-exemple.fr', nil)
  end

  it 'gives the requests the scopes of the DataPass formulaire merged with the editor data' do
    expect(result.created.map { |request| request.authorization_request.scopes }).to all(eq(%w[entreprises etablissements]))
    expect(result.created.map { |request| request.authorization_request.intitule }).to all(eq('Dématérialisation des marchés publics'))
  end

  it 'reports invalid SIRET, duplicates and already imported requests' do
    expect(result.invalid_sirets).to eq(%w[213401722])
    expect(result.duplicates).to eq(%w[21340172201787])
    expect(result.already_imported).to eq([already_imported])
  end

  it 'lists the requests to invite, already imported ones included so that the file can be generated again' do
    expect(result.editor_delegation_requests.map(&:siret)).to contain_exactly('21340172201787', '21340172201795', already_imported.siret)
  end

  it 'is idempotent' do
    described_class.call(editor_use_case:, rows:)

    expect { result }.not_to change(EditorDelegationRequest, :count)
    expect(result.already_imported.size).to eq(3)
  end
end
