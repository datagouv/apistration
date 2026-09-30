# frozen_string_literal: true

require 'rails_helper'

RSpec.describe DatapassWebhook::FindOrCreateUser, type: :interactor do
  describe '.call' do
    subject { described_class.call(datapass_webhook_params) }

    let(:datapass_webhook_params) { build(:datapass_webhook, demandeur_attributes:) }
    let(:demandeur_attributes) do
      {
        email: generate(:email)
      }
    end

    context 'when there is no user with the same email' do
      it { is_expected.to be_a_success }
      it { expect(subject.user).to an_instance_of(User) }

      it 'creates a new user with valid attributes' do
        expect {
          subject
        }.to change(User, :count).by(1)

        user = User.last

        expect(user.oauth_api_gouv_id).to be_present
        expect(user.first_name).to eq('demandeur first name')
        expect(user.last_name).to eq('demandeur last name')
      end
    end

    context 'when in staging' do
      before { allow(Rails.env).to receive(:staging?).and_return(true) }

      it 'creates an anonymized user' do
        user = subject.user.reload

        expect(user.email).to match(/\Aanon-\h{12}@yopmail\.com\z/)
        expect(user.first_name).to match(/\APrénom \h{6}\z/)
      end

      it 'finds the same anonymized user when the same demandeur comes back' do
        first_user = subject.user
        webhook_with_same_demandeur = build(:datapass_webhook, demandeur_attributes: { email: demandeur_attributes[:email].upcase })

        expect {
          expect(described_class.call(webhook_with_same_demandeur)).to be_a_success
        }.not_to change(User, :count)

        expect(User.find_by(email: demandeur_attributes[:email])).to eq(first_user)
        expect(first_user.reload.email).not_to eq(demandeur_attributes[:email])
      end
    end

    context 'when there is already a user with the same email' do
      let!(:user) { create(:user, email: demandeur_attributes[:email]) }

      it { is_expected.to be_a_success }
      it { expect(subject.user).to eq(user) }

      it 'does not create a new user' do
        expect {
          subject
        }.not_to change(User, :count)
      end

      it 'updates existing user with attributes' do
        expect {
          subject
        }.to change { user.reload.first_name }.to('demandeur first name')
      end
    end
  end
end
