require 'rails_helper'

RSpec.describe DatapassWebhook::APIParticulier::CreateHubEESubscription, type: :interactor do
  subject(:interactor) { described_class.call(**params) }

  let(:authorization_request) { create(:authorization_request) }
  let(:hubee_api_client) { instance_double(HubEEAPIClient) }
  let(:stripped_hubee_organization_payload) { { 'branchCode' => '132456', 'companyRegister' => '123456789', 'id' => '123456789' } }
  let(:stripped_hubee_subscription_payload) { { 'id' => 'ABC123456789' } }
  let(:params) { { authorization_request:, hubee_organization_payload: stripped_hubee_organization_payload } }

  context 'when everything works as expected' do
    before do
      allow(HubEEAPIClient).to receive(:new).and_return(hubee_api_client)
      allow(hubee_api_client).to receive(:create_subscription).and_return(stripped_hubee_subscription_payload)
    end

    it 'creates a subscription on HubEE' do
      expect(hubee_api_client).to receive(:create_subscription).with(authorization_request, stripped_hubee_organization_payload, 'FormulaireQF')
      interactor
    end

    context 'when the service provider is an editor' do
      let(:authorization_request) { create(:authorization_request, extra_infos: { 'service_provider' => { 'type' => 'editor', 'siret' => '13002526500013' } }) }

      it 'creates the subscription without any editor delegation' do
        expect(hubee_api_client).to receive(:create_subscription).with(authorization_request, stripped_hubee_organization_payload, 'FormulaireQF')
        interactor
      end
    end

    it 'saves the HubEE subscription id to the authorization request' do
      expect {
        interactor
      }.to change { authorization_request.reload.extra_infos['hubee_subscription_id'] }.from(nil).to('ABC123456789')
    end

    it 'adds the HubEE subscription payload to the context' do
      expect(interactor.hubee_subscription_payload).to eq(stripped_hubee_subscription_payload)
    end

    it { is_expected.to be_a_success }
  end

  context 'when HubEE raises an error' do
    before do
      allow(HubEEAPIClient).to receive(:new).and_return(hubee_api_client)
      allow(hubee_api_client).to receive(:create_subscription).and_raise(Faraday::BadRequestError)
    end

    it 'raises an error' do
      expect { interactor }.to raise_error(Faraday::BadRequestError)
    end
  end
end
