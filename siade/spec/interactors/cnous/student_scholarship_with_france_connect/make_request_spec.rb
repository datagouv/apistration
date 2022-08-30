RSpec.describe CNOUS::StudentScholarshipWithFranceConnect::MakeRequest, type: :make_request do
  subject(:make_call) { described_class.call(params:, token:) }

  let(:params) { default_france_connect_identity_attributes.merge(user_id:) }
  let(:body) { default_france_connect_identity_attributes.to_json }

  let(:user_id) { SecureRandom.uuid }
  let(:token) { 'dummy_oauth_token' }

  let!(:stubbed_request) do
    stub_request(:get, Siade.credentials[:cnous_student_scholarship_france_connect_url]).with(
      body:,
      headers: {
        'X-API-Key' => "Bearer #{token}",
        'X-Caller' => "DINUM - #{user_id}"
      }
    )
      .to_return(
        status: 200,
        body: File.read(Rails.root.join('spec/fixtures/payloads/cnous_student_scholarship_valid_response.json'))
      )
  end

  it { is_expected.to be_a_success }

  its(:response) { is_expected.to be_a(Net::HTTPOK) }

  it 'calls url with valid params and headers' do
    make_call

    expect(stubbed_request).to have_been_requested
  end
end
