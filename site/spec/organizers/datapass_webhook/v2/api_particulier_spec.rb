# frozen_string_literal: true

require 'rails_helper'

RSpec.describe DatapassWebhook::V2::APIParticulier, type: :interactor do
  subject { described_class.call(datapass_webhook_params) }

  let(:datapass_webhook_params) do
    params = build(:datapass_webhook_v2, event: 'approve')

    %w[family_name given_name email phone_number job_title].each do |attribute|
      params['data']['data'].delete "contact_metier_#{attribute}"
    end

    params['data']['data']['scopes'] = ['cnaf_quotient_familial']

    params
  end

  before do
    stub_brevo_contacts_upsert
  end

  it_behaves_like 'datapass webhooks', 'v2'

  it 'creates an authorization request with particulier api' do
    expect(subject.authorization_request.api).to eq('particulier')
  end

  it 'does not creates contact metier' do
    expect {
      subject
    }.not_to change(UserAuthorizationRequestRole.where(role: 'contact_metier'), :count)
  end

  it 'creates token for API Particulier' do
    subject

    last_token = Token.last

    expect(last_token.api).to eq('particulier')
  end

  context 'when modalities does no include params' do
    before do
      datapass_webhook_params['data']['data']['modalities'] = ['formulaire_qf']
    end

    it 'does not create a token' do
      expect {
        subject
      }.not_to change(Token, :count)
    end
  end

  describe 'modalities' do
    context 'when modalities does not include formulaire_qf' do
      before do
        datapass_webhook_params['data']['data']['modalities'] = ['params']
      end

      it 'does not schedule a job to create formulaire qf resources' do
        expect {
          subject
        }.not_to have_enqueued_job(CreateFormulaireQFResourcesJob)
      end
    end

    context 'when modalities include formulaire_qf' do
      before do
        datapass_webhook_params['data']['data']['modalities'] = ['formulaire_qf']
      end

      context 'when event is approve' do
        before do
          datapass_webhook_params['event'] = 'approve'
        end

        it 'schedules a job to create formulaire qf resources' do
          expect {
            subject
          }.to have_enqueued_job(CreateFormulaireQFResourcesJob)
        end
      end

      context 'when event not approve' do
        before do
          datapass_webhook_params['event'] = 'reject'
        end

        it 'does not schedule a job to create formulaire qf resources' do
          expect {
            subject
          }.not_to have_enqueued_job(CreateFormulaireQFResourcesJob)
        end
      end
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

  describe 'when the form is the DataPass form of a use case of an editor' do
    let!(:editor) { create(:editor) }

    before { create(:editor_use_case, editor:, form_uid: 'api-entreprise') }

    it 'creates an editor delegation for that editor' do
      expect { subject }.to change(EditorDelegation, :count).by(1)

      expect(EditorDelegation.last.editor).to eq(editor)
    end
  end

  describe 'Brevo adding contacts' do
    it 'adds each contact to the API Particulier list with its roles' do
      subject

      expect(
        brevo_contact_upsert(
          email: 'applicant@gouv.fr',
          attributes: {
            'PRENOM' => 'Nicolas',
            'NOM' => 'Demandeur',
            'CONTACT_DEMANDEUR' => true,
            'CONTACT_TECHNIQUE' => false
          },
          list_id: 4
        )
      ).to have_been_made.once

      expect(
        brevo_contact_upsert(
          email: 'tech@gouv.fr',
          attributes: {
            'PRENOM' => 'Jean',
            'NOM' => 'Tech',
            'CONTACT_DEMANDEUR' => false,
            'CONTACT_TECHNIQUE' => true
          },
          list_id: 4
        )
      ).to have_been_made.once
    end
  end

  it 'affects authorization request data to authorization_request_data on context' do
    expect(subject.authorization_request_data).to eq(datapass_webhook_params['data']['data'])
  end
end
