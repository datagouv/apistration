# frozen_string_literal: true

RSpec.shared_examples 'a datapass webhook organizer' do |api_name, brevo_list_id|
  subject { described_class.call(datapass_webhook_params) }

  let(:datapass_webhook_params) do
    build(:datapass_webhook,
      event: 'approve',
      authorization_request_attributes: {
        copied_from_enrollment_id: previous_enrollment_id
      })
  end

  let(:previous_enrollment_id) { generate(:authorization_request, :external_id) }
  let(:token) { create(:token) }

  before do
    stub_brevo_contacts_upsert
    # No yield here - specific setups should be in the specs
  end

  it_behaves_like 'datapass webhooks'

  it "creates an authorization request with #{api_name} api" do
    expect(subject.authorization_request.api).to eq(api_name)
  end

  it 'creates token for API' do
    expect {
      subject
    }.to change(Token, :count).by(1)

    token = Token.find(subject.token_id)
    expect(token.api).to eq(api_name)
  end

  describe 'Brevo adding contacts' do
    it "adds contacts to the API #{api_name.capitalize} list" do
      subject

      expect(
        a_request(:post, BrevoAPIMocks::BREVO_CONTACTS_URL).with(body: hash_including(listIds: [brevo_list_id]))
      ).to have_been_made.at_least_once
    end
  end
end
