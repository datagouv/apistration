require 'rails_helper'

RSpec.describe Admin::Tokens::Ban, type: :organizer do
  include ActiveJob::TestHelper

  describe '.call' do
    subject { described_class.call(token:, admin:, comment:, namespace: 'entreprise') }

    let(:admin) { create(:user, :admin) }
    let(:authorization_request) { create(:authorization_request, :with_all_contacts, api: 'entreprise') }
    let!(:token) { create(:token, authorization_request:) }
    let(:comment) { nil }

    context 'when token is valid and active' do
      it { is_expected.to be_a_success }

      it 'does not create a new token: contacts create one themselves' do
        expect { subject }.not_to change(Token, :count)
      end

      it 'blacklists the token in 30 days' do
        subject
        expect(token.reload.blacklisted_at).to be_within(1.minute).of(1.month.from_now)
      end

      it 'delivers a single ban email to every contact of the demande' do
        perform_enqueued_jobs { subject }

        expect(ActionMailer::Base.deliveries.size).to eq(1)
        expect(ActionMailer::Base.deliveries.last.to).to contain_exactly(
          authorization_request.demandeur.email,
          authorization_request.contact_technique.email,
          authorization_request.contact_metier.email
        )
      end

      it 'records an admin activity' do
        expect { subject }.to change(AdminActivity, :count).by(1)

        expect(AdminActivity.last).to have_attributes(
          name: 'token_banned',
          admin:,
          namespace: 'entreprise',
          entity: token
        )
      end

      it 'stores the ban details in the activity' do
        subject

        expect(AdminActivity.last.before_attributes).to eq('blacklisted_at' => nil)
        expect(AdminActivity.last.after_attributes).to include('comment' => nil)
      end

      context 'when comment is provided' do
        let(:comment) { 'Token was compromised' }

        it 'delivers the ban email with the admin comment' do
          perform_enqueued_jobs { subject }

          expect(ActionMailer::Base.deliveries.last.html_part.decoded).to include('Token was compromised')
        end

        it 'stores the comment in the activity' do
          subject

          expect(AdminActivity.last.after_attributes).to include('comment' => 'Token was compromised')
        end
      end

      context 'when blacklisted_at is provided' do
        subject { described_class.call(token:, admin:, comment:, blacklisted_at:, namespace: 'entreprise') }

        let(:blacklisted_at) { 7.days.from_now }

        it 'blacklists the token at the specified date' do
          subject
          expect(token.reload.blacklisted_at).to be_within(1.second).of(blacklisted_at)
        end
      end
    end

    context 'when a contact revoked the token after the admin opened it' do
      it 'does not reactivate it with a later ban date' do
        stale_token = Token.find(token.id)
        token.revoke!
        revoked_at = token.reload.blacklisted_at

        expect(described_class.call(token: stale_token, admin:, comment:, namespace: 'entreprise')).to be_a_failure
        expect(token.reload.blacklisted_at).to eq(revoked_at)
      end
    end

    context 'when an earlier ban is already scheduled' do
      before { token.update!(blacklisted_at: 3.days.from_now) }

      it 'keeps the earlier date' do
        subject

        expect(token.reload.blacklisted_at).to be_within(1.second).of(3.days.from_now)
      end
    end

    context 'when token is already blacklisted' do
      let!(:token) { create(:token, :blacklisted, authorization_request:) }

      it { is_expected.to be_a_failure }

      it 'does not send emails' do
        expect { subject }.not_to have_enqueued_job(ActionMailer::MailDeliveryJob)
      end
    end

    context 'when token does not exist' do
      subject { described_class.call(token: nil, comment: nil, namespace: 'entreprise') }

      it { is_expected.to be_a_failure }

      it 'does not send emails' do
        expect { subject }.not_to have_enqueued_job(ActionMailer::MailDeliveryJob)
      end
    end
  end
end
