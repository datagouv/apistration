RSpec.describe Admin::Editors::AddMember, type: :organizer do
  subject(:result) { described_class.call(editor:, email:, admin:, namespace: 'entreprise') }

  let(:editor) { create(:editor) }
  let(:admin) { create(:user, :admin) }

  context 'with an existing user' do
    let(:user) { create(:user) }
    let(:email) { user.email }

    it 'adds the user to the editor' do
      expect(result).to be_success
      expect(user.reload.editor).to eq(editor)
    end

    it 'records an admin activity' do
      expect { result }.to change(AdminActivity, :count).by(1)

      expect(AdminActivity.last).to have_attributes(
        name: 'editor_member_added',
        admin:,
        namespace: 'entreprise',
        entity: user,
        before_attributes: { 'email' => user.email, 'editor_id' => nil },
        after_attributes: { 'email' => user.email, 'editor_id' => editor.id }
      )
    end
  end

  context 'when user is already a member' do
    let(:user) { create(:user, editor:) }
    let(:email) { user.email }

    it 'fails' do
      expect(result).to be_failure
      expect(result.message).to include('déjà membre')
    end

    it 'does not record any admin activity' do
      expect { result }.not_to change(AdminActivity, :count)
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
