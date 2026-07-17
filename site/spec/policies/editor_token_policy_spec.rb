RSpec.describe EditorTokenPolicy do
  subject(:policy) { described_class.new(user, editor_token) }

  let(:editor) { create(:editor) }
  let(:user) { create(:user, editor:) }
  let(:editor_token) { create(:editor_token, editor:) }

  describe '#create?' do
    it 'allows a user attached to an editor' do
      expect(policy.create?).to be true
    end

    context 'when the user has no editor' do
      let(:user) { create(:user) }

      it 'denies' do
        expect(policy.create?).to be false
      end
    end
  end

  %i[update? rotate? revoke?].each do |action|
    describe "##{action}" do
      it 'allows the owner editor on an active token' do
        expect(policy.public_send(action)).to be true
      end

      context 'when the token belongs to another editor' do
        let(:editor_token) { create(:editor_token) }

        it 'denies' do
          expect(policy.public_send(action)).to be false
        end
      end

      context 'when the user has no editor' do
        let(:user) { create(:user) }

        it 'denies' do
          expect(policy.public_send(action)).to be false
        end
      end

      context 'when the token is expired' do
        let(:editor_token) { create(:editor_token, :expired, editor:) }

        it 'denies' do
          expect(policy.public_send(action)).to be false
        end
      end

      context 'when the token is already revoked' do
        let(:editor_token) { create(:editor_token, :blacklisted, editor:) }

        it 'denies' do
          expect(policy.public_send(action)).to be false
        end
      end
    end
  end
end
