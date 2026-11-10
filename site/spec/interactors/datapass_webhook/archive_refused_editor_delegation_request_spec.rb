RSpec.describe DatapassWebhook::ArchiveRefusedEditorDelegationRequest, type: :interactor do
  subject { described_class.call(event:, authorization_request:, reopening:) }

  let(:reopening) { false }

  let(:authorization_request) { create(:authorization_request, status: 'refused') }
  let!(:delegation) { create(:editor_delegation, authorization_request:) }

  context 'when an editor delegation request is refused' do
    let(:event) { %w[refuse refuse_application].sample }

    before { create(:editor_delegation_request, authorization_request:) }

    it 'archives the authorization request, which cuts the access through the editor' do
      subject

      expect(authorization_request.reload).to be_archived
      expect(delegation.reload.revoked_at).to be_present
    end
  end

  context 'when the reopening of a validated editor delegation request is refused' do
    let(:event) { 'refuse' }
    let(:reopening) { true }
    let(:authorization_request) { create(:authorization_request, :validated) }

    before { create(:editor_delegation_request, authorization_request:) }

    it 'keeps the running habilitation' do
      subject

      expect(authorization_request.reload.status).to eq('validated')
      expect(delegation.reload.revoked_at).to be_nil
    end
  end

  context 'when another authorization request is refused' do
    let(:event) { 'refuse' }

    it 'does not archive it' do
      subject

      expect(authorization_request.reload.status).to eq('refused')
      expect(delegation.reload.revoked_at).to be_nil
    end
  end

  context 'when an editor delegation request is not refused' do
    let(:event) { 'submit' }

    before { create(:editor_delegation_request, authorization_request:) }

    it 'does not archive it' do
      subject

      expect(authorization_request.reload.status).to eq('refused')
    end
  end
end
