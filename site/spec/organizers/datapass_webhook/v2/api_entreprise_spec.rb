# frozen_string_literal: true

require 'rails_helper'

RSpec.describe DatapassWebhook::V2::APIEntreprise, type: :interactor do
  subject { described_class.call(datapass_webhook_params) }

  let(:datapass_webhook_params) do
    build(
      :datapass_webhook_v2,
      event: 'approve',
      demarche: 'editeurs'
    )
  end

  let(:token) { create(:token) }

  before do
    stub_brevo_contacts_upsert
  end

  it_behaves_like 'datapass webhooks', 'v2'

  it 'creates one contact metier' do
    expect { subject }.to change(UserAuthorizationRequestRole.where(role: 'contact_metier'), :count).by(1)
  end

  it 'creates an authorization request with entreprise api, demarche and public id' do
    expect(subject.authorization_request.api).to eq('entreprise')
    expect(subject.authorization_request.demarche).to eq('api-entreprise')
    expect(subject.authorization_request.public_id).to be_present
  end

  describe 'when contact metier is empty (non-regression test)' do
    before do
      %w[family_name given_name email phone_number job_title].each do |attribute|
        datapass_webhook_params['data']['data']["contact_metier_#{attribute}"] = nil
      end
    end

    it 'creates token for API Entreprise and stores id in token_id' do
      expect {
        subject
      }.to change(Token, :count).by(1)

      token = Token.find(subject.token_id)

      expect(token.api).to eq('entreprise')
    end
  end

  describe 'when the form belongs to an editor' do
    let!(:editor) { create(:editor, form_uids: ['api-entreprise']) }

    it 'creates an editor delegation attributed to datapass_auto' do
      expect { subject }.to change(EditorDelegation, :count).by(1)

      expect(EditorDelegation.last.editor).to eq(editor)
      expect(EditorDelegation.last).to be_datapass_auto
    end
  end

  describe 'Brevo adding contacts' do
    it 'adds each contact to the API Entreprise list with its roles' do
      subject

      expect(
        brevo_contact_upsert(
          email: 'applicant@gouv.fr',
          attributes: {
            'PRENOM' => 'Nicolas',
            'NOM' => 'Demandeur',
            'CONTACT_DEMANDEUR' => true,
            'CONTACT_TECHNIQUE' => false,
            'CONTACT_METIER' => false
          },
          list_id: 3
        )
      ).to have_been_made.once

      expect(
        brevo_contact_upsert(
          email: 'metier@gouv.fr',
          attributes: {
            'PRENOM' => 'Jacques',
            'NOM' => 'Metier',
            'CONTACT_DEMANDEUR' => false,
            'CONTACT_TECHNIQUE' => false,
            'CONTACT_METIER' => true
          },
          list_id: 3
        )
      ).to have_been_made.once

      expect(
        brevo_contact_upsert(
          email: 'tech@gouv.fr',
          attributes: {
            'PRENOM' => 'Jean',
            'NOM' => 'Tech',
            'CONTACT_DEMANDEUR' => false,
            'CONTACT_TECHNIQUE' => true,
            'CONTACT_METIER' => false
          },
          list_id: 3
        )
      ).to have_been_made.once
    end
  end

  describe 'when demandeur, contact technique and contact metier are the same' do
    let(:email) { generate(:email) }

    before do
      %w[contact_metier contact_technique].each do |role|
        %w[family_name given_name email].each do |attribute|
          datapass_webhook_params['data']['data']["#{role}_#{attribute}"] = datapass_webhook_params['data']['applicant'][attribute]
        end
      end
    end

    it 'creates one contact metier' do
      expect {
        subject
      }.to change(UserAuthorizationRequestRole.where(role: 'contact_metier'), :count).by(1)
    end
  end
end
