require 'rails_helper'

RSpec.describe TokenExpirationNoticeJob do
  include ActiveJob::TestHelper

  subject { described_class.perform_now }

  shared_examples 'sending expiration notices' do |nb_days|
    it "sends notifications for token expiration in #{nb_days} days" do
      notifier_spy = class_spy(Token::SendExpirationNotices)
      stub_const('Token::SendExpirationNotices', notifier_spy)

      subject

      expect(notifier_spy).to have_received(:call).with(expire_in: nb_days)
    end
  end

  it_behaves_like 'sending expiration notices', 0
  it_behaves_like 'sending expiration notices', 7
  it_behaves_like 'sending expiration notices', 15
  it_behaves_like 'sending expiration notices', 30
  it_behaves_like 'sending expiration notices', 60
  it_behaves_like 'sending expiration notices', 90

  describe 'when there is a token with an expiration date in 7 days' do
    let!(:token) { create(:token, exp: 7.days.from_now, days_left_notification_sent:) }

    before do
      clear_enqueued_jobs
    end

    context 'when none of the expiration notice has been sent' do
      let(:days_left_notification_sent) { [] }

      it 'sent the notification for 7 days' do
        expect {
          subject
        }.to have_enqueued_job(ScheduleExpirationNoticeEmailJob).with(token, 7)
      end

      it 'only sent one email' do
        expect {
          subject
        }.to change(enqueued_jobs, :size).by(1)

        expect(token.reload.days_left_notification_sent).to eq([7])
      end
    end
  end

  describe 'expiration notices over the life of a token' do
    def notices_sent_to(token)
      enqueued_jobs
        .select { |job| job[:job] == ScheduleExpirationNoticeEmailJob }
        .map { |job| ActiveJob::Arguments.deserialize(job[:args]) }
        .filter_map { |notified_token, days| days if notified_token == token }
    end

    before do
      clear_enqueued_jobs
    end

    it 'does not notify a token expired for more than a day' do
      token = create(:token, exp: 2.days.ago.to_i)

      subject

      expect(notices_sent_to(token)).to be_empty
    end

    it 'sends only the 30-day notice to a token 20 days from expiration which only got the 90-day one' do
      token = create(:token, exp: 20.days.from_now.to_i, days_left_notification_sent: [90])

      subject

      expect(notices_sent_to(token)).to eq([30])
    end

    it 'sends each notice once over the life of a token' do
      token = create(:token, exp: 91.days.from_now.to_i)

      (0..(93 * 6)).each do |run|
        Timecop.travel((run * 4).hours.from_now) { described_class.perform_now }
      end

      expect(notices_sent_to(token)).to eq([90, 60, 30, 15, 7, 0])
    end

    it 'sends the 0-day notice on the day of expiration' do
      token = create(:token, exp: 1.hour.ago.to_i, days_left_notification_sent: [90, 60, 30, 15, 7])

      subject

      expect(notices_sent_to(token)).to eq([0])
    end

    it 'does not notify a blacklisted token' do
      token = create(:token, :blacklisted, exp: 20.days.from_now.to_i, days_left_notification_sent: [90])

      subject

      expect(notices_sent_to(token)).to be_empty
    end

    it 'does not notify a token whose authorization request is archived' do
      authorization_request = create(:authorization_request, status: 'archived')
      token = create(:token, authorization_request:, exp: 20.days.from_now.to_i, days_left_notification_sent: [90])

      subject

      expect(notices_sent_to(token)).to be_empty
    end
  end
end
