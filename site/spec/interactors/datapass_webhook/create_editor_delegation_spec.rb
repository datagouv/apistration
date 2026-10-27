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

  it 'emits a delegation granted by the DataPass webhook' do
    expect { result }.to emit_security_event('delegation.editor.granted').with(
      target: { type: 'editor_delegation', id: kind_of(String) },
      details: { source: 'datapass_webhook', editor_id: editor.id, datapass_id: authorization_request.external_id }
    )
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

    it 'emits no delegation granted' do
      expect { result }.not_to emit_security_event('delegation.editor.granted')
    end
  end
end
