RSpec.describe DatapassWebhook::CreateEditorDelegation do
  subject(:result) { described_class.call(event:, authorization_request:) }

  let(:event) { 'approve' }
  let(:authorization_request) { create(:authorization_request, demarche: 'umad-editor') }
  let!(:editor) { create(:editor) }

  it 'creates a delegation attributed to datapass_auto, even for an editor with delegations disabled' do
    expect { result }.to change(EditorDelegation, :count).by(1)

    expect(result).to be_success
    expect(result.delegation).to be_datapass_auto
    expect(result.delegation.editor).to eq(editor)
    expect(result.delegation.authorization_request).to eq(authorization_request)
  end

  context 'when the event is not a validation' do
    let(:event) { 'refuse' }

    it 'does not create a delegation' do
      expect { result }.not_to change(EditorDelegation, :count)
      expect(result).to be_success
    end
  end

  context 'when no editor matches the demarche' do
    let(:authorization_request) { create(:authorization_request, demarche: 'entreprise-classique') }

    it 'does not create a delegation' do
      expect { result }.not_to change(EditorDelegation, :count)
      expect(result).to be_success
    end
  end

  context 'when an active delegation already exists' do
    before { create(:editor_delegation, editor:, authorization_request:) }

    it 'does not create a duplicate' do
      expect { result }.not_to change(EditorDelegation, :count)
      expect(result).to be_success
    end
  end

  context 'when the authorization request comes from an editor delegation request' do
    let(:authorization_request) { create(:authorization_request, demarche: 'api-entreprise-marches-publics') }
    let(:use_case_editor) { create(:editor, form_uids: []) }

    before { create(:editor_delegation_request, authorization_request:, editor_use_case: create(:editor_use_case, editor: use_case_editor)) }

    it 'delegates to the editor of the use case' do
      expect(result.delegation.editor).to eq(use_case_editor)
    end

    context 'when the import already opened the delegation' do
      let!(:delegation) { create(:editor_delegation, editor: use_case_editor, authorization_request:, created_via: 'editor_delegation_request') }

      it 'keeps it' do
        expect { result }.not_to change(EditorDelegation, :count)

        expect(result.delegation).to eq(delegation)
      end
    end
  end
end
