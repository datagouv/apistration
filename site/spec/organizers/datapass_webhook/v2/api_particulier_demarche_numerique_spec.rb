# frozen_string_literal: true

require 'rails_helper'

RSpec.describe DatapassWebhook::V2::APIParticulierDemarcheNumerique, type: :interactor do
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
    allow(Mailjet::Contactslist_managemanycontacts).to receive(:create)
  end

  it_behaves_like 'datapass webhooks', 'v2'

  it 'creates an authorization request with particulier api' do
    expect(subject.authorization_request.api).to eq('particulier')
  end

  it 'creates token for API Particulier' do
    subject

    expect(Token.last.api).to eq('particulier')
  end

  describe 'Mailjet adding contacts' do
    it 'adds contacts to Particulier mailjet list' do
      expect(Mailjet::Contactslist_managemanycontacts).to receive(:create).with(
        hash_including(id: AdminApientreprise.credentials[:mj_list_id_particulier]),
        any_args
      )

      subject
    end
  end

  it 'does not schedule any authorization request email' do
    expect { subject }.not_to have_enqueued_job(ScheduleAuthorizationRequestEmailJob)
  end

  it 'does not schedule a formulaire qf resources job' do
    expect { subject }.not_to have_enqueued_job(CreateFormulaireQFResourcesJob)
  end

  it 'does not notify reporters' do
    expect(APIParticulier::ReportersMailer).not_to receive(:with)

    subject
  end
end
