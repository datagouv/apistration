require 'rails_helper'

RSpec.describe Admin::Tokens::Ban, type: :organizer do
  include ActiveJob::TestHelper

  describe '.call' do
    subject { described_class.call(token:, admin:, comment:, namespace: 'entreprise') }

    let(:admin) { create(:user, :admin) }
    let(:authorization_request) { create(:authorization_request, :with_demandeur, :with_contact_technique, api: 'entreprise') }
    let!(:token) { create(:token, authorization_request:) }
    let(:comment) { nil }

    context 'when token is valid and active' do
      it { is_expected.to be_a_success }

      it 'creates a new token' do
        expect { subject }.to change(Token, :count).by(1)
      end

      it 'blacklists the original token in 30 days' do
        subject
        expect(token.reload.blacklisted_at).to be_within(1.minute).of(1.month.from_now)
      end

      it 'sets the new token iat to current time' do
        subject
        new_token = Token.where.not(id: token.id).order(created_at: :desc).first
        expect(new_token.iat).to be_within(5).of(Time.zone.now.to_i)
      end

      it 'does not blacklist the newly generated token' do
        subject
        new_token = Token.where.not(id: token.id).order(created_at: :desc).first
        expect(new_token.blacklisted_at).to be_nil
      end

      it 'delivers the ban email to the demandeur and the contact technique' do
        perform_enqueued_jobs { subject }

        expect(ActionMailer::Base.deliveries.map(&:to)).to contain_exactly(
          [authorization_request.demandeur.email],
          [authorization_request.contact_technique.email]
        )
      end

      it 'emits a ban effective in a month, with the DataPass id' do
        expect { subject }.to emit_security_event('token.api_token.banned').with(
          actor: { email: admin.email, role: 'admin' },
          target: { type: 'token', id: token.id },
          details: { blacklisted_at: be_within(1.minute).of(1.month.from_now), datapass_id: authorization_request.external_id }
        )
      end

      it 'emits the creation of the replacement token' do
        expect { subject }.to emit_security_event('token.api_token.created').with(
          actor: { email: admin.email, role: 'admin' },
          target: { type: 'token', id: satisfy { |id| id.present? && id != token.id } },
          details: hash_including(source: 'admin_ban', datapass_id: authorization_request.external_id)
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

        new_token = Token.where.not(id: token.id).order(created_at: :desc).first

        expect(AdminActivity.last.before_attributes).to eq('blacklisted_at' => nil)
        expect(AdminActivity.last.after_attributes).to include(
          'generate_new_token' => true,
          'new_token_id' => new_token.id
        )
      end

      context 'when comment is provided' do
        let(:comment) { 'Token was compromised' }

        it { is_expected.to be_a_success }

        it 'delivers the ban email with the admin comment to each recipient' do
          perform_enqueued_jobs { subject }

          expect(ActionMailer::Base.deliveries.size).to eq(2)
          expect(ActionMailer::Base.deliveries.map { |mail| mail.html_part.decoded }).to all(include('Token was compromised'))
        end

        it 'stores the comment in the activity' do
          subject

          expect(AdminActivity.last.after_attributes).to include('comment' => 'Token was compromised')
        end
      end

      context 'when blacklisted_at is provided' do
        subject { described_class.call(token:, admin:, comment:, blacklisted_at:, namespace: 'entreprise') }

        let(:blacklisted_at) { 7.days.from_now }

        it { is_expected.to be_a_success }

        it 'blacklists the token at the specified date' do
          subject
          expect(token.reload.blacklisted_at).to be_within(1.second).of(blacklisted_at)
        end
      end

      context 'when generate_new_token is false' do
        subject { described_class.call(token:, admin:, comment:, generate_new_token: false, namespace: 'entreprise') }

        it { is_expected.to be_a_success }

        it 'does not create a new token' do
          expect { subject }.not_to change(Token, :count)
        end

        it 'emits no token creation' do
          expect { subject }.not_to emit_security_event('token.api_token.created')
        end

        it 'blacklists the original token' do
          subject
          expect(token.reload.blacklisted_at).to be_within(1.minute).of(1.month.from_now)
        end

        it 'delivers the ban email without announcing a new token' do
          perform_enqueued_jobs { subject }

          expect(ActionMailer::Base.deliveries.size).to eq(2)
          expect(ActionMailer::Base.deliveries.map { |mail| mail.html_part.decoded }.join).not_to include('Un nouveau token')
        end
      end
    end

    context 'when token is already blacklisted' do
      let!(:token) { create(:token, :blacklisted, authorization_request:) }

      it { is_expected.to be_a_failure }

      it 'does not create a new token' do
        initial_count = Token.count
        subject
        expect(Token.count).to eq(initial_count)
      end

      it 'does not send emails' do
        expect { subject }.not_to have_enqueued_job(ActionMailer::MailDeliveryJob)
      end

      it 'emits no ban' do
        expect { subject }.not_to emit_security_event('token.api_token.banned')
      end
    end

    context 'when token does not exist' do
      subject { described_class.call(token: nil, comment: nil, namespace: 'entreprise') }

      it { is_expected.to be_a_failure }

      it 'does not create a new token' do
        initial_count = Token.count
        subject
        expect(Token.count).to eq(initial_count)
      end

      it 'does not send emails' do
        expect { subject }.not_to have_enqueued_job(ActionMailer::MailDeliveryJob)
      end
    end

    context 'when authorization request has no contact_technique' do
      let(:authorization_request) { create(:authorization_request, :with_demandeur, api: 'entreprise') }

      it { is_expected.to be_a_success }

      it 'delivers the ban email only to the demandeur' do
        perform_enqueued_jobs { subject }

        expect(ActionMailer::Base.deliveries.map(&:to)).to contain_exactly([authorization_request.demandeur.email])
      end
    end
  end
end
