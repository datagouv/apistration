RSpec.describe Admin::Editors::RemoveMember, type: :organizer do
  subject(:result) { described_class.call(editor:, user_id:, admin:, namespace: 'entreprise') }

  let(:editor) { create(:editor) }
  let(:admin) { create(:user, :admin) }

  context 'with a member of the editor' do
    let(:user) { create(:user, editor:) }
    let(:user_id) { user.id }

    it 'removes the user from the editor' do
      expect(result).to be_success
      expect(user.reload.editor).to be_nil
    end

    it 'records an admin activity' do
      expect { result }.to change(AdminActivity, :count).by(1)

      expect(AdminActivity.last).to have_attributes(
        name: 'editor_member_removed',
        admin:,
        namespace: 'entreprise',
        entity: user,
        before_attributes: { 'email' => user.email, 'editor_id' => editor.id },
        after_attributes: { 'email' => user.email, 'editor_id' => nil }
      )
    end
  end

  context 'with a user not in the editor' do
    let(:user) { create(:user) }
    let(:user_id) { user.id }

    it 'fails' do
      expect(result).to be_failure
      expect(result.message).to include('non trouvé')
    end

    it 'does not record any admin activity' do
      expect { result }.not_to change(AdminActivity, :count)
    end
  end
end
