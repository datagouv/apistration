RSpec.describe EditorDelegation::AutoCreate do
  subject(:result) { described_class.call(event:, authorization_request:) }

  let(:event) { 'approve' }
  let(:authorization_request) { create(:authorization_request, demarche: 'umad-editor') }
  let!(:editor) { create(:editor, :delegable) }

  it 'creates a delegation attributed to datapass_auto' do
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

  context 'when the matching editor is not delegable' do
    let!(:editor) { create(:editor) }

    before { allow(Sentry).to receive(:capture_message) }

    it 'alerts without failing the webhook' do
      expect { result }.not_to change(EditorDelegation, :count)
      expect(result).to be_success
      expect(Sentry).to have_received(:capture_message).with(/not delegable/, level: :warning)
    end
  end
end
