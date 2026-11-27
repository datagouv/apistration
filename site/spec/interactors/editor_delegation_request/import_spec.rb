RSpec.describe EditorDelegationRequest::Import do
  subject(:result) { described_class.call(editor_delegation_campaign:, rows:) }

  let(:editor_delegation_campaign) { create(:editor_delegation_campaign) }
  let!(:already_imported) { create(:editor_delegation_request, editor_delegation_campaign:, siret: '21030190500019', contact_email: 'mairie@exemple.fr') }
  let(:rows) do
    [
      { 'siret' => '21340172201787', 'contact_email' => ' achats@saint-exemple.fr ' },
      { 'siret' => '213 401 722 01795', 'contact_email' => nil },
      { 'siret' => '213401722', 'contact_email' => 'siren@exemple.fr' },
      { 'siret' => '21340172201788', 'contact_email' => 'luhn@exemple.fr' },
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

  context 'when the editor provides the data protection officer' do
    let(:rows) do
      [
        {
          'siret' => '21340172201787',
          'contact_email' => 'achats@saint-exemple.fr',
          'delegue_protection_donnees_given_name' => 'Dominique',
          'delegue_protection_donnees_family_name' => 'Leroy',
          'delegue_protection_donnees_email' => ' DPO@saint-exemple.fr ',
          'delegue_protection_donnees_phone_number' => '0123456789',
          'delegue_protection_donnees_job_title' => 'DPO'
        },
        { 'siret' => '21340172201795', 'contact_email' => 'achats@saint-exemple.fr', 'delegue_protection_donnees_email' => '' }
      ]
    end

    it 'prefills it on the request, so that the signatory only checks it' do
      expect(result.created.first).to be_valid(:data_protection_officer)
      expect(result.created.first.delegue_protection_donnees_email).to eq('dpo@saint-exemple.fr')
      expect(result.created.last.data).to be_empty
    end
  end

  context 'when the editor provides a business contact for each establishment' do
    let(:rows) do
      [
        {
          'siret' => '21340172201787',
          'contact_email' => 'achats@saint-exemple.fr',
          'contact_metier_given_name' => 'Camille',
          'contact_metier_family_name' => 'Martin',
          'contact_metier_email' => ' Directrice@Creche.fr ',
          'contact_metier_phone_number' => '0612345678',
          'contact_metier_job_title' => 'Directrice'
        },
        { 'siret' => '21340172201795', 'contact_email' => 'achats@saint-exemple.fr', 'contact_metier_email' => '' }
      ]
    end

    it 'keeps it on the request, the campaign contact applying where the cell is empty' do
      expect(result.created.first.datapass_contacts).to eq(
        'contact_metier_given_name' => 'Camille',
        'contact_metier_family_name' => 'Martin',
        'contact_metier_email' => 'directrice@creche.fr',
        'contact_metier_phone_number' => '0612345678',
        'contact_metier_job_title' => 'Directrice'
      )
      expect(result.created.last.datapass_contacts).to be_empty
    end
  end

  context 'when a column is not a DataPass field' do
    let(:rows) { [{ 'siret' => '21340172201787', 'contact_email' => 'achats@saint-exemple.fr', 'contact_metir_email' => 'directrice@creche.fr' }] }

    it 'imports nothing and names the column, so that a typo never sends the campaign contact instead' do
      expect { result }.not_to change(EditorDelegationRequest, :count)

      expect(result).to be_failure
      expect(result.message).to eq('Colonnes inconnues : contact_metir_email')
    end
  end

  context 'when a filled column has no header' do
    let(:rows) { [{ 'siret' => '21340172201787', 'contact_email' => 'achats@saint-exemple.fr', nil => 'directrice@creche.fr' }] }

    it 'imports nothing, the data of that column having nowhere to go' do
      expect { result }.not_to change(EditorDelegationRequest, :count)

      expect(result.message).to eq('Colonnes inconnues : (sans en-tête)')
    end
  end

  context 'when the file ends with an empty column without header' do
    let(:rows) { [{ 'siret' => '21340172201787', 'contact_email' => 'achats@saint-exemple.fr', nil => nil }] }

    it 'imports the rows' do
      expect { result }.to change(EditorDelegationRequest, :count).by(1)
    end
  end

  it 'gives the requests the scopes of the DataPass formulaire merged with the editor data' do
    expect(result.created.map { |request| request.authorization_request.scopes }).to all(eq(%w[entreprises etablissements]))
    expect(result.created.map { |request| request.authorization_request.intitule }).to all(eq('Dématérialisation des marchés publics'))
  end

  it 'reports SIRET that DataPass would refuse, duplicates and already imported requests' do
    expect(result.invalid_sirets).to eq(%w[213401722 21340172201788])
    expect(result.duplicates).to eq(%w[21340172201787])
    expect(result.already_imported).to eq([already_imported])
  end

  it 'lists the requests to invite, already imported ones included so that the file can be generated again' do
    expect(result.editor_delegation_requests.map(&:siret)).to contain_exactly('21340172201787', '21340172201795', already_imported.siret)
  end

  it 'is idempotent' do
    described_class.call(editor_delegation_campaign:, rows:)

    expect { result }.not_to change(EditorDelegationRequest, :count)
    expect(result.already_imported.size).to eq(3)
  end
end
