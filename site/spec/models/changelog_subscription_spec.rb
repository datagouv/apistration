require 'rails_helper'

RSpec.describe ChangelogSubscription do
  describe 'factory' do
    it 'is valid' do
      expect(build(:changelog_subscription)).to be_valid
    end
  end

  describe 'validations' do
    it 'requires a known scope' do
      subscription = build(:changelog_subscription, scope: 'foo')

      expect(subscription).not_to be_valid
      expect(subscription.errors[:scope]).to be_present
    end

    it 'requires uniqueness on user/scope pair' do
      existing = create(:changelog_subscription)
      duplicate = build(:changelog_subscription, user: existing.user, scope: existing.scope)

      expect(duplicate).not_to be_valid
    end

    it 'allows the same user to subscribe to both scopes' do
      user = create(:user)
      create(:changelog_subscription, user:, scope: 'api_entreprise')
      other = build(:changelog_subscription, user:, scope: 'api_particulier')

      expect(other).to be_valid
    end

    it 'allows resubscribing once a previous subscription is disabled' do
      previous = create(:changelog_subscription)
      previous.disable!
      other = build(:changelog_subscription, user: previous.user, scope: previous.scope)

      expect(other).to be_valid
    end
  end

  describe '#disable!' do
    it 'sets disabled_at and keeps the row' do
      subscription = create(:changelog_subscription)

      expect { subscription.disable! }.to change(subscription, :disabled_at).from(nil)
      expect(described_class.exists?(subscription.id)).to be true
    end

    it 'is idempotent' do
      subscription = create(:changelog_subscription, disabled_at: 1.day.ago)
      original = subscription.disabled_at

      subscription.disable!

      expect(subscription.reload.disabled_at).to be_within(1.second).of(original)
    end
  end

  describe 'unsubscribe_token' do
    it 'is generated automatically on create' do
      subscription = create(:changelog_subscription)

      expect(subscription.unsubscribe_token).to be_present
    end

    it 'is unique across subscriptions' do
      first = create(:changelog_subscription)
      second = create(:changelog_subscription, user: create(:user))

      expect(first.unsubscribe_token).not_to eq(second.unsubscribe_token)
    end
  end

  describe '#covers?' do
    let(:subscription) { build(:changelog_subscription, scope: 'api_entreprise') }

    it { expect(subscription.covers?('api_entreprise')).to be true }
    it { expect(subscription.covers?('both')).to be true }
    it { expect(subscription.covers?('api_particulier')).to be false }
  end
end
