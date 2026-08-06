RSpec.describe HubEEAPIClient do
  let(:hubee_api_authentication) { instance_double(HubEEAPIAuthentication, access_token: 'access_token') }

  before do
    allow(HubEEAPIAuthentication).to receive(:new).and_return(hubee_api_authentication)
  end

  describe '#find_organization' do
    subject(:find_organization_payload) { described_class.new.find_organization(organization) }

    let(:organization) { create(:organization, siret:) }
    let(:siret) { '13002526500013' }
    let(:code_commune) { '13055' }
    let(:host) { AdminApientreprise.credentials[:hubee_api_url] }

    before do
      allow(organization).to receive(:code_commune_etablissement).and_return(code_commune)
    end

    context 'when the API returns a 200' do
      let(:valid_payload) { hubee_organization_payload(siret:, code_commune:) }

      before do
        stub_request(:get, "#{host}/referential/v1/organizations/SI-#{siret}-#{code_commune}").to_return(
          status: 200,
          headers: { 'Content-Type' => 'application/json' },
          body: valid_payload.to_json
        )
      end

      it 'renders a valid json from payload' do
        expect(find_organization_payload).to eq(valid_payload)
      end
    end

    context 'when API returns 404' do
      before do
        stub_request(:get, "#{host}/referential/v1/organizations/SI-#{siret}-#{code_commune}").to_return(
          status: 404,
          headers: { 'Content-Type' => 'application/json' },
          body: {
            'header' => {
              'statut' => 404,
              'message' => "Aucun élément trouvé pour le siret #{siret}"
            }
          }.to_json
        )
      end

      it 'raises a NotFound error' do
        expect { find_organization_payload }.to raise_error(HubEEAPIClient::NotFound)
      end
    end

    context 'when API returns unknown status' do
      before do
        stub_request(:get, "#{host}/referential/v1/organizations/SI-#{siret}-#{code_commune}").to_return(
          status: 500
        )
      end

      it 'raises an error' do
        expect { find_organization_payload }.to raise_error(Faraday::Error)
      end
    end
  end

  describe '#create_subscription' do
    subject(:create_subscription) { described_class.new.create_subscription(authorization_request, organization_payload, process_code) }

    let(:authorization_request) { create(:authorization_request, :with_demandeur, api: 'particulier') }
    let(:organization_payload) { hubee_organization_payload }
    let(:process_code) { 'FormulaireQF' }
    let(:host) { Rails.application.credentials.hubee_api_url }
    let(:subscription_payload) { hubee_subscription_payload(authorization_request:, process_code:) }

    context 'when the subscription does not exist yet' do
      before do
        stub_request(:post, "#{host}/referential/v1/subscriptions").to_return(
          status: 201,
          headers: { 'Content-Type' => 'application/json' },
          body: subscription_payload.to_json
        )
      end

      it 'returns the created subscription payload' do
        expect(create_subscription).to eq(subscription_payload)
      end

      it 'does not activate the subscription' do
        create_subscription

        expect(a_request(:put, %r{#{host}/referential/v1/subscriptions/})).not_to have_been_made
      end
    end

    context 'when the subscription already exists' do
      before do
        stub_request(:post, "#{host}/referential/v1/subscriptions").to_return(
          status: 400,
          headers: { 'Content-Type' => 'application/json' },
          body: { 'errors' => [{ 'message' => 'Subscription already exists' }] }.to_json
        )
        stub_request(:get, "#{host}/referential/v1/subscriptions")
          .with(query: { companyRegister: organization_payload['companyRegister'], processCode: process_code })
          .to_return(
            status: 200,
            headers: { 'Content-Type' => 'application/json' },
            body: [subscription_payload].to_json
          )
      end

      it 'returns the existing subscription payload' do
        expect(create_subscription).to eq(subscription_payload)
      end

      it 'does not activate the subscription' do
        create_subscription

        expect(a_request(:put, %r{#{host}/referential/v1/subscriptions/})).not_to have_been_made
      end
    end
  end
end
