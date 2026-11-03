RSpec.describe TokenDecorator do
  before do
    Timecop.freeze('01/01/2023')
  end

  after do
    Timecop.return
  end

  describe '#passed_time_as_ratio' do
    subject { described_class.new(token).passed_time_as_ratio }

    context 'when token is expired' do
      let(:token) { create(:token, created_at: 1.year.ago, exp: 6.months.ago) }

      it { is_expected.to eq(100) }
    end

    context 'when token is valid' do
      let(:token) { create(:token, created_at: 1.year.ago, exp: 1.year.from_now) }

      it { is_expected.to eq(50) }
    end
  end

  describe '#progress_bar_color' do
    subject { described_class.new(token).progress_bar_color }

    context 'when token is valid for more than 90 days' do
      let(:token) { create(:token, created_at: 1.year.ago, exp: 120.days.from_now) }

      it { is_expected.to eq('green') }
    end

    context 'when token is valid for less than 90 days' do
      let(:token) { create(:token, created_at: 1.year.ago, exp: 89.days.from_now) }

      it { is_expected.to eq('orange') }
    end

    context 'when token is valid for less than 30 days' do
      let(:token) { create(:token, created_at: 1.year.ago, exp: 6.days.from_now) }

      it { is_expected.to eq('red') }
    end
  end

  describe '#status' do
    subject { described_class.new(token).status }

    context 'when expired' do
      let(:token) { create(:token, exp: 1.day.ago) }

      it { is_expected.to eq('expired') }
    end

    context 'when blacklisted' do
      let(:token) { create(:token, blacklisted_at: 1.day.ago) }

      it { is_expected.to eq('revoked') }
    end

    context 'when now_token' do
      let(:token) { create(:token) }

      it { is_expected.to eq('new_token') }
    end

    context 'when active' do
      let!(:access_log) { create(:access_log, token:) }
      let(:token) { create(:token) }

      it { is_expected.to eq('active') }
    end
  end

  describe '#card_end_timestamp' do
    it 'shows the expiry date of an expired token whose ban was scheduled later' do
      token = create(:token, exp: 1.day.ago.to_i, blacklisted_at: 1.day.from_now).decorate

      expect(token.card_status).to eq('expired')
      expect(token.card_end_timestamp).to eq(token.exp)
    end

    it 'shows the ban date of a revoked token' do
      blacklisted_at = 2.days.ago.change(usec: 0)
      token = create(:token, exp: 1.year.from_now.to_i, blacklisted_at:).decorate

      expect(token.card_end_timestamp).to eq(blacklisted_at.to_i)
    end
  end
end
