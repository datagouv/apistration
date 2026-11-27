RSpec.describe EditorDelegationRequest::Create do
  subject(:result) { described_class.call(editor_delegation_campaign:, datapass_data:, siret:, contact_email: 'achats@saint-exemple.fr') }

  let(:editor_delegation_campaign) { create(:editor_delegation_campaign) }
  let(:siret) { '21340172201787' }
  let(:datapass_data) do
    {
      'intitule' => 'Marchés publics',
      'description' => 'Pièces justificatives',
      'scopes' => %w[entreprises open_data_unites_legales]
    }
  end

  it 'creates a local draft authorization request, without DataPass id, carrying the merged scopes' do
    expect(result).to be_success

    expect(result.authorization_request).to have_attributes(
      api: 'entreprise',
      demarche: 'api-entreprise-marches-publics',
      siret:,
      status: 'draft',
      external_id: nil,
      intitule: 'Marchés publics',
      description: 'Pièces justificatives',
      scopes: %w[entreprises open_data]
    )
  end

  context 'when the campaign belongs to API Particulier' do
    let(:editor_delegation_campaign) { create(:editor_delegation_campaign, api: 'particulier', datapass_form_uid: 'api-particulier-tarification-eaje') }

    it 'creates the draft on API Particulier, so that its DataPass webhooks and the delegation reach this API' do
      expect(result.authorization_request).to have_attributes(api: 'particulier', demarche: 'api-particulier-tarification-eaje')
    end
  end

  it 'opens an active delegation to the editor right away' do
    delegation = result.authorization_request.editor_delegations.sole

    expect(delegation.editor).to eq(editor_delegation_campaign.editor)
    expect(delegation.revoked_at).to be_nil
    expect(delegation).to be_editor_delegation_request
  end

  it 'attaches the delegation request' do
    expect(result.editor_delegation_request).to have_attributes(
      editor_delegation_campaign:,
      siret:,
      contact_email: 'achats@saint-exemple.fr',
      authorization_request: result.authorization_request
    )
  end

  it 'creates the organization and refreshes its INSEE data' do
    expect { result }.to change(Organization, :count).by(1)

    expect(UpdateOrganizationINSEEPayloadJob).to have_been_enqueued.with(Organization.find_by(siret:).id)
  end

  context 'when the organization already exists' do
    before { create(:organization, siret:) }

    it 'reuses it' do
      expect { result }.not_to change(Organization, :count)
    end
  end

  context 'when the request already exists' do
    before { create(:editor_delegation_request, editor_delegation_campaign:, siret:) }

    it 'fails without leaving anything behind' do
      expect { result }.not_to change(AuthorizationRequest, :count)

      expect(result).to be_failure
      expect(EditorDelegation.count).to eq(0)
    end
  end
end
