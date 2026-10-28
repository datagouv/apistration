# frozen_string_literal: true

require 'rails_helper'

RSpec.describe DatapassWebhook::UpdateScopes, type: :interactor do
  subject { described_class.call(datapass_webhook_params.merge(authorization_request:)) }

  let(:authorization_request) { create(:authorization_request, scopes: %w[entreprises]) }
  let(:datapass_webhook_params) { build(:datapass_webhook, event:) }
  let(:scopes) do
    {
      'associations' => true,
      'entreprises' => true
    }
  end

  before do
    datapass_webhook_params['data']['pass']['scopes'] = scopes
  end

  context 'when event is not approve' do
    let(:event) { 'whatever' }

    it { is_expected.to be_a_success }

    it 'leaves the scopes of the demande untouched' do
      expect { subject }.not_to change { authorization_request.reload.scopes }
    end
  end

  context 'when event is approve' do
    let(:event) { 'approve' }

    it { is_expected.to be_a_success }

    it 'creates no token' do
      expect { subject }.not_to change(Token, :count)
    end

    it 'updates the scopes of the demande' do
      subject

      expect(authorization_request.reload.scopes).to contain_exactly('associations', 'entreprises')
    end

    context 'when there is some scopes starting with open_data_' do
      let(:scopes) do
        {
          'open_data_associations' => true,
          'entreprises' => true
        }
      end

      it 'adds open_data scope and removes the entries starting with open_data_' do
        subject

        expect(authorization_request.reload.scopes).to contain_exactly('open_data', 'entreprises')
      end
    end

    context 'when the demande already has tokens' do
      let!(:active_token) { create(:token, authorization_request:, scopes: %w[entreprises], exp: 2.months.from_now.to_i) }
      let!(:other_active_token) { create(:token, authorization_request:, name: 'Recette', scopes: %w[entreprises]) }
      let!(:revoked_token) { create(:token, authorization_request:, scopes: %w[entreprises], blacklisted_at: 1.day.ago) }

      it 'gives every active token the scopes of the demande, without prolonging it' do
        expect { subject }.not_to change { active_token.reload.exp }

        expect(active_token.reload.scopes).to contain_exactly('associations', 'entreprises')
        expect(other_active_token.reload.scopes).to contain_exactly('associations', 'entreprises')
      end

      it 'leaves revoked tokens untouched' do
        expect { subject }.not_to change { revoked_token.reload.scopes }
      end
    end
  end
end
