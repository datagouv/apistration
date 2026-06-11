RSpec.describe Admin::Editor::RemoveMember do
  subject(:result) { described_class.call(editor:, user_id:) }

  let(:editor) { create(:editor) }

  context 'with a member of the editor' do
    let(:user) { create(:user, editor:) }
    let(:user_id) { user.id }

    it 'removes the user from the editor' do
      expect(result).to be_success
      expect(user.reload.editor).to be_nil
    end
  end

  context 'with a user not in the editor' do
    let(:user) { create(:user) }
    let(:user_id) { user.id }

    it 'fails' do
      expect(result).to be_failure
      expect(result.message).to include('non trouvé')
    end
  end
end
