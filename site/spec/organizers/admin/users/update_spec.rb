RSpec.describe Admin::Users::Update, type: :organizer do
  subject(:result) { described_class.call(user:, user_params:, admin:, namespace: 'entreprise') }

  let(:admin) { create(:user, :admin) }
  let(:previous_editor) { create(:editor) }
  let(:user) { create(:user, editor: previous_editor) }

  context 'when the admin moves the user to another editor' do
    let(:editor) { create(:editor) }
    let(:user_params) { { editor_id: editor.id, provider_uids: [] } }

    it 'emits an editor membership change from the previous editor to the new one' do
      expect { result }.to emit_security_event('access.editor_membership.changed').with(
        actor: { email: admin.email, role: 'admin' },
        target: { type: 'user', id: user.id },
        details: { editor_id: editor.id, previous_editor_id: previous_editor.id }
      )
    end
  end

  context 'when the admin keeps the editor of the user' do
    let(:user_params) { { editor_id: previous_editor.id, provider_uids: [] } }

    it 'emits no editor membership change' do
      expect { result }.not_to emit_security_event('access.editor_membership.changed')
    end
  end

  context 'when the admin gives the user another provider' do
    let(:user) { create(:user, provider_uids: %w[dgfip]) }
    let(:user_params) { { editor_id: nil, provider_uids: %w[dgfip insee] } }

    it 'emits a provider membership change with both lists' do
      expect { result }.to emit_security_event('access.provider_membership.changed').with(
        actor: { email: admin.email, role: 'admin' },
        target: { type: 'user', id: user.id },
        details: { provider_uids: %w[dgfip insee], previous_provider_uids: %w[dgfip] }
      )
    end
  end

  context 'when the admin keeps the providers of the user' do
    let(:user) { create(:user, provider_uids: %w[dgfip]) }
    let(:user_params) { { editor_id: nil, provider_uids: %w[dgfip] } }

    it 'emits no provider membership change' do
      expect { result }.not_to emit_security_event('access.provider_membership.changed')
    end
  end
end
