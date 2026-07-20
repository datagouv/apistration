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

  describe '#prolong?' do
    let(:editor_token) { create(:editor_token, editor:, exp: 1.month.from_now.to_i) }

    it 'allows the owner when the token expires in less than 90 days' do
      expect(policy.prolong?).to be true
    end

    context 'when the token expires in more than 90 days' do
      let(:editor_token) { create(:editor_token, editor:, exp: 6.months.from_now.to_i) }

      it 'denies' do
        expect(policy.prolong?).to be false
      end
    end

    context 'when the token is blacklisted' do
      let(:editor_token) { create(:editor_token, :blacklisted, editor:, exp: 1.month.from_now.to_i) }

      it 'denies' do
        expect(policy.prolong?).to be false
      end
    end

    context 'when the token belongs to another editor' do
      let(:editor_token) { create(:editor_token, exp: 1.month.from_now.to_i) }

      it 'denies' do
        expect(policy.prolong?).to be false
      end
    end

    context 'when the user has no editor' do
      let(:user) { create(:user) }

      it 'denies' do
        expect(policy.prolong?).to be false
      end
    end
  end
end
