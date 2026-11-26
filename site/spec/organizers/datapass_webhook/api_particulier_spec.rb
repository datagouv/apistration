# frozen_string_literal: true

require 'rails_helper'

RSpec.describe DatapassWebhook::APIParticulier, type: :interactor do
  it_behaves_like 'a datapass webhook organizer', 'particulier', 4 do
    let(:datapass_webhook_params) do
      build(:datapass_webhook,
        event: 'approve',
        authorization_request_attributes: {
          scopes: { 'cnaf_quotient_familial' => true },
          team_members: team_members_payload
        },
        extra_data: { 'external_token_id' => legacy_token_id })
    end

    let(:team_members_payload) do
      [
        build(:datapass_webhook_team_member_model, type: 'demandeur'),
        build(:datapass_webhook_team_member_model, type: 'responsable_technique')
      ]
    end

    let(:legacy_token_id) { 'over-9000' }
  end

  describe 'API Particulier specific behavior' do
    subject { described_class.call(datapass_webhook_params) }

    let(:datapass_webhook_params) do
      build(:datapass_webhook,
        event: 'approve',
        authorization_request_attributes: {
          scopes: { 'cnaf_quotient_familial' => true },
          team_members: team_members_payload
        },
        extra_data: { 'external_token_id' => legacy_token_id })
    end

    let(:team_members_payload) do
      [
        build(:datapass_webhook_team_member_model, type: 'demandeur'),
        build(:datapass_webhook_team_member_model, type: 'responsable_technique')
      ]
    end

    let(:legacy_token_id) { 'over-9000' }

    before do
      stub_brevo_contacts_upsert
    end

    it 'does not creates contact metier' do
      expect {
        subject
      }.not_to change(UserAuthorizationRequestRole.where(role: 'contact_metier'), :count)
    end

    it 'creates token with legacy token id in extra infos' do
      subject
      last_token = Token.last
      expect(last_token.extra_info).to have_key('legacy_token_id')
      expect(last_token.extra_info['legacy_token_id']).to eq(legacy_token_id)
    end
  end
end
