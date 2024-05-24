RSpec.describe CNOUS::StudentScholarshipWithFranceConnect::MakeRequest, type: :make_request do
  subject(:make_call) { described_class.call(params:, token:, operation_id: 'whatever') }

  let(:params) { default_france_connect_v1_identity_attributes }
  let(:body) { default_france_connect_v1_identity_attributes.to_json }

  let(:token) { 'dummy_oauth_token' }

  let!(:stubbed_request) do
    stub_request(:get, Siade.credentials[:cnous_student_scholarship_france_connect_url]).with(
      body:,
      headers: {
        'Authorization' => "Bearer #{token}"
      }
    ).to_return(
      status: 200,
      body: cnous_valid_payload('france_connect').to_json
    )
  end

  it { is_expected.to be_a_success }

  its(:response) { is_expected.to be_a(Net::HTTPOK) }

  it 'calls url with valid params and headers' do
    make_call

    expect(stubbed_request).to have_been_requested
  end

  context 'when in staging' do
    before do
      allow(Rails.env).to receive(:staging?).and_return(true)
      allow(MockDataBackend).to receive(:get_response_for).with(
        'whatever',
        hash_including(
          {
            given_name: 'Jean Martin',
            birthcountry: '99100'
          }
        )
      ).and_return(cnous_valid_payload('france_connect'))
    end

    it { is_expected.to be_a_success }
  end
end
