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

    it 'creates the authorization request without contact metier' do
      expect { subject }.to change(AuthorizationRequest, :count).by(1)
    end
  end

  describe 'when the form belongs to an editor' do
    let!(:editor) { create(:editor, form_uids: ['api-entreprise']) }

    it 'creates an editor delegation attributed to datapass_auto' do
      expect { subject }.to change(EditorDelegation, :count).by(1)

      expect(EditorDelegation.last.editor).to eq(editor)
      expect(EditorDelegation.last).to be_datapass_auto
    end

    it 'still creates a token: the editor is not ready with its editor tokens' do
      expect { subject }.to change(Token, :count).by(1)
    end

    context 'when the editor is ready with its editor tokens' do
      let!(:editor) { create(:editor, :delegable, form_uids: ['api-entreprise']) }

      it 'creates no token: the editor calls the API with its own tokens' do
        expect { subject }.not_to change(Token, :count)
      end

      it 'emits no token creation' do
        expect { subject }.not_to emit_security_event('token.api_token.created')
      end
    end
  end

  describe 'on a first validation' do
    include ActiveJob::TestHelper

    it 'creates a main token carrying the scopes of the demande' do
      token = subject.authorization_request.tokens.sole

      expect(token.name).to eq('Jeton principal')
      expect(token.scopes).to eq(subject.authorization_request.scopes)
    end

    it 'emits the token creation by DataPass' do
      expect { subject }.to emit_security_event('token.api_token.created').with(
        details: hash_including(source: 'datapass_webhook')
      )
    end

    it 'exposes the created token id' do
      expect(subject.token_id).to eq(subject.authorization_request.tokens.sole.id)
    end

    it 'sends every contact the validation email, which announces the token' do
      perform_enqueued_jobs(only: ScheduleAuthorizationRequestEmailJob) { subject }

      expect(ActionMailer::MailDeliveryJob).to have_been_enqueued.with(
        'APIEntreprise::AuthorizationRequestMailer', 'demande_validee', 'deliver_now', hash_including(args: [hash_including(update: false)])
      )
      mail = APIEntreprise::AuthorizationRequestMailer.demande_validee(authorization_request: subject.authorization_request, to: ['applicant@gouv.fr'], update: false)
      expect(mail.subject).to include('votre jeton API Entreprise est disponible')
    end
  end

  describe 'when DataPass replays the approval' do
    before { described_class.call(datapass_webhook_params.deep_dup) }

    it 'creates no other token and prolongs nothing' do
      token = AuthorizationRequest.sole.tokens.sole

      expect { subject }.not_to(change { [Token.count, token.reload.exp] })
    end

    it 'answers the id of the token already created' do
      expect(subject.token_id).to eq(AuthorizationRequest.sole.tokens.sole.id)
    end
  end

  describe 'when a validated update arrives on a demande whose token expired' do
    before do
      datapass_webhook_params['data']['state'] = 'validated'
      described_class.call(datapass_webhook_params.deep_dup)
      AuthorizationRequest.sole.tokens.sole.update!(exp: 1.day.ago.to_i)
    end

    it 'creates no token: only a first validation does, contacts create the next ones' do
      expect { subject }.not_to change(Token, :count)
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
end
