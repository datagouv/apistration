require 'rails_helper'

RSpec.describe User do
  let(:user) { create(:user) }

  it 'has valid factories' do
    expect(build(:user)).to be_valid
  end

  describe 'constraints' do
    describe '#email' do
      it { is_expected.to allow_value('valid@email.com').for(:email) }
      it { is_expected.not_to allow_value('not an email').for(:email) }
    end
  end

  describe '.added_since_yesterday' do
    subject { described_class }

    let!(:user) { create(:user, added_datetime) }

    context 'when he has just been created' do
      let(:added_datetime) { :added_since_yesterday }

      its(:added_since_yesterday) { is_expected.to exist user.id }
    end

    context 'when he was created a long time ago' do
      let(:added_datetime) { :not_added_since_yesterday }

      its(:added_since_yesterday) { is_expected.not_to exist user.id }
    end
  end

  describe '#confirmed?' do
    subject { user.confirmed? }

    context 'when the user has an API Gouv ID' do
      before { user.oauth_api_gouv_id = '12' }

      it { is_expected.to be(true) }
    end

    context 'when the user does not have an API Gouv ID' do
      before { user.oauth_api_gouv_id = nil }

      it { is_expected.to be(false) }
    end

    context 'when the user has an empty API Gouv ID' do
      before { user.oauth_api_gouv_id = '' }

      it { is_expected.to be(false) }
    end
  end

  describe '#find_or_initialize_by_email' do
    subject { described_class.find_or_initialize_by_email(email) }

    let(:email) { 'email_WITH@case.COM' }

    context 'when email does not exist' do
      its(:id) { is_expected.to be_nil }
      its(:email) { is_expected.to eq email }
    end

    context 'when email already exists' do
      let!(:user) { create(:user, email:) }

      its(:id) { is_expected.to eq user.id }
      its(:email) { is_expected.to eq email.downcase }
    end

    context 'when email already exists with different case' do
      let!(:user) { create(:user, email: 'EMAIL_with@CASE.com') }

      its(:id) { is_expected.to eq user.id }
      its(:email) { is_expected.to eq 'email_with@case.com' }
    end
  end

  describe 'authorization_requests association' do
    subject { user.authorization_requests }

    let!(:authorization_request) { create(:authorization_request, :with_demandeur, :with_contact_metier, demandeur: user, contact_metier: user) }

    it 'sorts only once the authorization request' do
      expect(subject).to include(authorization_request)
      expect(subject.size).to eq(1)
    end
  end

  describe '#provider?' do
    context 'when user has provider_uids' do
      let(:user) { build(:user, provider_uids: ['insee']) }

      it 'returns true' do
        expect(user.provider?).to be true
      end
    end

    context 'when user has no provider_uids' do
      let(:user) { build(:user, provider_uids: []) }

      it 'returns false' do
        expect(user.provider?).to be false
      end
    end
  end

  describe 'admin?' do
    subject { described_class.find_or_initialize_by_email(email).admin? }

    context 'when in staging' do
      before do
        allow(Rails.env).to receive(:staging?).and_return(true)
      end

      context 'when email belongs to the yeswehack ninja domain' do
        let(:email) { 'test-ywhadmin@yopmail.com' }

        it { is_expected.to be(true) }
      end

      context 'when email is a specific admin email' do
        let(:email) { 'api-entreprise@yopmail.com' }

        it { is_expected.to be(true) }
      end

      context 'when email does not belong to an admin' do
        let(:email) { 'not_an_admin@yopmail.com' }

        it { is_expected.to be(false) }
      end
    end
  end

  it 'stores personal data as is outside staging' do
    user = create(:user, email: 'jean.dupont@example.gouv.fr', first_name: 'Jean', last_name: 'Dupont')

    expect(user.reload).to have_attributes(email: 'jean.dupont@example.gouv.fr', first_name: 'Jean', last_name: 'Dupont')
  end

  describe 'personal data anonymization in staging' do
    before { allow(Rails.env).to receive(:staging?).and_return(true) }

    let!(:user) { create(:user, email: 'Jean.Dupont@example.gouv.fr', first_name: 'Jean', last_name: 'Dupont') }

    it 'stores anonymized personal data' do
      expect(user.reload.email).to match(/\Aanon-\h{12}@yopmail\.com\z/)
      expect(user.first_name).to match(/\APrénom \h{6}\z/)
      expect(user.last_name).to match(/\ANom \h{6}\z/)
    end

    it 'still rejects invalid emails' do
      expect(build(:user, email: 'not an email')).not_to be_valid
    end

    it 'keeps finding the user by its real email' do
      expect(described_class.find_or_initialize_by_email('jean.dupont@example.gouv.fr')).to eq(user)
      expect(described_class.find_by(email: 'Jean.Dupont@example.gouv.fr')).to eq(user)
    end

    it 'keeps yopmail addresses, so hunters stay admins' do
      hunter = create(:user, email: 'hunter-ywhadmin@yopmail.com')

      expect(hunter.reload.email).to eq('hunter-ywhadmin@yopmail.com')
      expect(hunter).to be_admin
    end
  end
end
