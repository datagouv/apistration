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
    allow(Mailjet::Contactslist_managemanycontacts).to receive(:create)
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

  describe 'Mailjet adding contacts' do
    it 'adds contacts to Entreprise mailjet list' do
      expect(Mailjet::Contactslist_managemanycontacts).to receive(:create).with(
        id: AdminApientreprise.credentials[:mj_list_id_entreprise],
        action: 'addnoforce',
        contacts: [
          {
            email: 'applicant@gouv.fr',
            properties: {
              'contact_demandeur' => true,
              'contact_métier' => false,
              'contact_technique' => false,
              'nom' => 'Demandeur',
              'prénom' => 'Nicolas'
            }
          },
          {
            email: 'metier@gouv.fr',
            properties: {
              'contact_demandeur' => false,
              'contact_métier' => true,
              'contact_technique' => false,
              'nom' => 'Metier',
              'prénom' => 'Jacques'
            }
          },
          {
            email: 'tech@gouv.fr',
            properties: {
              'contact_demandeur' => false,
              'contact_métier' => false,
              'contact_technique' => true,
              'nom' => 'Tech',
              'prénom' => 'Jean'
            }
          }
        ]
      )

      subject
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

  describe 'when the demande comes from an editor delegation request' do
    include ActiveJob::TestHelper

    subject { described_class.call(datapass_webhook_params) }

    let(:editor) { create(:editor, form_uids: []) }
    let(:editor_delegation_request) do
      create(:editor_delegation_request, :with_authorization_request, siret: '21340172201787', editor_use_case: create(:editor_use_case, editor:))
    end
    let(:authorization_request) { editor_delegation_request.authorization_request }
    let!(:delegation) { create(:editor_delegation, editor:, authorization_request:, created_via: 'editor_delegation_request') }

    let(:datapass_webhook_params) do
      build(
        :datapass_webhook_v2,
        event:,
        data: build(
          :datapass_webhook_data_v2,
          state:,
          form_uid: 'api-entreprise-marches-publics',
          organization: build(:datapass_webhook_organization_v2, siret: '21340172201787')
        )
      )
    end

    before do
      allow(Rails.application).to receive(:config_for).and_call_original
      allow(Rails.application).to receive(:config_for).with('datapass_webhooks_entreprise').and_return(
        Rails.application.config_for('datapass_webhooks_entreprise', env: 'production')
      )
    end

    after { clear_enqueued_jobs }

    context 'when DataPass sends the submission before its id is stored' do
      let(:event) { 'submit' }
      let(:state) { 'submitted' }

      it 'updates the local authorization request, which keeps its delegation' do
        expect { subject }.not_to change(AuthorizationRequest, :count)

        expect(authorization_request.reload.external_id).to eq(datapass_webhook_params['model_id'].to_s)
        expect(authorization_request.status).to eq('submitted')
        expect(delegation.reload.revoked_at).to be_nil
      end

      it 'sends the dedicated mail' do
        subject

        expect(ScheduleAuthorizationRequestEmailJob).to have_been_enqueued.with(authorization_request.id, 'submitted', 'delegation_editeur_demande_recue', anything)
      end
    end

    context 'when DataPass approves the demande' do
      let(:event) { 'approve' }
      let(:state) { 'validated' }

      before { authorization_request.update!(external_id: datapass_webhook_params['model_id']) }

      it 'validates the authorization request without any token, keeping the delegation' do
        expect { subject }.not_to change(Token, :count)

        expect(authorization_request.reload.validated_at).to be_present
        expect(EditorDelegation.active.where(authorization_request:)).to contain_exactly(delegation)
        expect(subject.token_id).to be_nil
      end

      it 'sends the dedicated mail' do
        subject

        expect(ScheduleAuthorizationRequestEmailJob).to have_been_enqueued.with(authorization_request.id, 'validated', 'delegation_editeur_demande_validee', anything)
      end
    end

    context 'when DataPass refuses the demande' do
      let(:event) { 'refuse' }
      let(:state) { 'refused' }

      before { authorization_request.update!(external_id: datapass_webhook_params['model_id']) }

      it 'archives the authorization request, which revokes the delegation' do
        subject

        expect(authorization_request.reload).to be_archived
        expect(delegation.reload.revoked_at).to be_present
      end

      it 'sends the dedicated mail' do
        subject

        expect(ScheduleAuthorizationRequestEmailJob).to have_been_enqueued.with(authorization_request.id, 'archived', 'delegation_editeur_demande_refusee', anything)
      end
    end
  end
end
