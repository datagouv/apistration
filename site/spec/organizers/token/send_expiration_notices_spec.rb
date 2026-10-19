require 'rails_helper'

RSpec.describe Token::SendExpirationNotices, type: :organizer do
  describe 'expire_in: option (provide a number of days)' do
    subject { described_class.call(expire_in: days) }

    let(:days) { 90 }

    shared_examples 'sends the right expiration notices' do
      it { is_expected.to be_success }

      it 'calls the mailer for the affected tokens only' do
        expect { subject }
          .to have_enqueued_job(ScheduleExpirationNoticeEmailJob).with(one_token_expired_within_3_month, days)
          .and have_enqueued_job(ScheduleExpirationNoticeEmailJob).with(another_token_expired_within_3_month, days)
          .and have_enqueued_job(ScheduleExpirationNoticeEmailJob).exactly(2).times
      end

      it 'does not send the same notification twice' do
        described_class.call(expire_in: days)

        expect { subject }.not_to have_enqueued_job(ScheduleExpirationNoticeEmailJob)
      end

      it 'does not call the mailer for archived tokens' do
        authorization_request = create(:authorization_request, previous_external_id: 1234, status: 'archived')
        create(:token, :expiring_within_3_month, authorization_request:)

        expect { subject }
          .to have_enqueued_job(ScheduleExpirationNoticeEmailJob).with(one_token_expired_within_3_month, days)
          .and have_enqueued_job(ScheduleExpirationNoticeEmailJob).with(another_token_expired_within_3_month, days)
          .and have_enqueued_job(ScheduleExpirationNoticeEmailJob).exactly(2).times
      end

      it 'does not call the mailer for blacklisted tokens' do
        create(:token, :expiring_within_3_month, :blacklisted)

        expect { subject }
          .to have_enqueued_job(ScheduleExpirationNoticeEmailJob).with(one_token_expired_within_3_month, days)
          .and have_enqueued_job(ScheduleExpirationNoticeEmailJob).with(another_token_expired_within_3_month, days)
          .and have_enqueued_job(ScheduleExpirationNoticeEmailJob).exactly(2).times
      end

      it 'saves that the notification has been sent' do
        subject
        one_token_expired_within_3_month.reload
        another_token_expired_within_3_month.reload

        expect([one_token_expired_within_3_month, another_token_expired_within_3_month]).to all(have_attributes(days_left_notification_sent: a_collection_including(days)))
      end
    end

    describe 'when API Entreprise' do
      let!(:one_token_expired_within_3_month) { create(:token, :expiring_within_3_month) }
      let!(:another_token_expired_within_3_month) { create(:token, :expiring_within_3_month) }
      let!(:token_expired_within_1_year) { create(:token, :expiring_in_1_year) }

      it_behaves_like 'sends the right expiration notices'
    end

    describe 'when API Particulier' do
      let!(:one_token_expired_within_3_month) { create(:token, :expiring_within_3_month, :with_api_particulier) }
      let!(:another_token_expired_within_3_month) { create(:token, :expiring_within_3_month, :with_api_particulier) }
      let!(:token_expired_within_1_year) { create(:token, :expiring_in_1_year, :with_api_particulier) }

      it_behaves_like 'sends the right expiration notices'
    end
  end
end
