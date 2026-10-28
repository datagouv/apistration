require 'rails_helper'

RSpec.describe ScheduleExpirationNoticeEmailJob do
  describe '#perform' do
    subject do
      described_class.perform_now(token_id, expires_in)
    end

    let(:expires_in) { 30 }
    let(:authorization_request) { create(:authorization_request, :with_demandeur, :with_contact_technique) }
    let(:token) { create(:token, authorization_request:, exp: expires_in.days.from_now.to_i - 3600) }
    let(:token_id) { token.id }

    context 'when token id is not found' do
      let(:token_id) { 0 }

      it 'does nothing' do
        expect { subject }.not_to have_enqueued_mail(APIEntreprise::TokenMailer)

        subject
      end
    end

    context 'when the job was enqueued for a notice removed at the switch' do
      let(:expires_in) { 90 }

      it 'is dropped' do
        expect { subject }.not_to have_enqueued_mail(APIEntreprise::TokenMailer)
      end
    end

    context 'when expires_in is not a notice day' do
      let(:expires_in) { 45 }

      it 'fails loudly' do
        expect { subject }.to raise_error(ArgumentError, /45 days/)
      end
    end

    context 'when token is found and expires_in is valid' do
      let(:external_id) { '9001' }

      before do
        token.authorization_request.update!(external_id:)
      end

      it 'sends the correct mail' do
        expect { subject }.to have_enqueued_mail(APIEntreprise::TokenMailer, :expiration_notice).with(params: { token:, days: 30 }, args: [])

        subject
      end
    end

    context 'when token is expired' do
      let(:expires_in) { 0 }

      it 'sends the correct mail' do
        expect { subject }.to have_enqueued_mail(APIEntreprise::TokenMailer, :expiration_notice).with(params: { token:, days: 0 }, args: [])

        subject
      end
    end

    context 'when the token was extended after the notice was scheduled' do
      before { token.update!(exp: 6.months.from_now.to_i) }

      it 'sends nothing' do
        expect { subject }.not_to have_enqueued_mail(APIEntreprise::TokenMailer)
      end
    end

    context 'when the token was revoked after the notice was scheduled' do
      before { token.revoke! }

      it 'sends nothing' do
        expect { subject }.not_to have_enqueued_mail(APIEntreprise::TokenMailer)
      end
    end
  end
end
