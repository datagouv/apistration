RSpec.describe Admin::Editor::AddMember do
  subject(:result) { described_class.call(editor:, email:) }

  let(:editor) { create(:editor) }

  context 'with an existing user' do
    let(:user) { create(:user) }
    let(:email) { user.email }

    it 'adds the user to the editor' do
      expect(result).to be_success
      expect(user.reload.editor).to eq(editor)
    end
  end

  context 'when user is already a member' do
    let(:user) { create(:user, editor:) }
    let(:email) { user.email }

    it 'fails' do
      expect(result).to be_failure
      expect(result.message).to include('déjà membre')
    end
  end

  context 'with an unknown email' do
    let(:email) { 'unknown@test.com' }

    it 'fails' do
      expect(result).to be_failure
      expect(result.message).to include('Aucun utilisateur')
    end
  end
end
