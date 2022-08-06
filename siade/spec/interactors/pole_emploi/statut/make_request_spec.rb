RSpec.describe PoleEmploi::Statut::MakeRequest, type: :make_request do
  subject(:make_call) { described_class.call(token:, params:) }

  let(:token) { 'token' }
  let(:user_id) { SecureRandom.uuid }

  let(:params) do
    {
      identifiant:,
      user_id:
    }
  end
  let(:identifiant) { 'whatever' }

  let!(:stubbed_request) do
    stub_request(:post, Siade.credentials[:pole_emploi_status_url]).with(
      body: identifiant,
      headers: {
        'Content-Type' => 'application/json',
        'Authorization' => "Bearer #{token}",
        'X-pe-consommateur' => "DINUM - #{user_id}"
      }
    ).to_return(
      status: 200,
      body: File.read(Rails.root.join('spec/fixtures/payloads/pole_emploi_statut_valid_payload.json'))
    )
  end

  it { is_expected.to be_a_success }

  its(:response) { is_expected.to be_a(Net::HTTPOK) }

  it 'calls url with valid body, which interpolates params' do
    make_call

    expect(stubbed_request).to have_been_requested
  end
end
