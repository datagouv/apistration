RSpec.describe CNOUS::StudentScholarshipWithCivility::MakeRequest, type: :make_request do
  subject(:make_call) { described_class.call(params:, token:) }

  let(:params) do
    {
      family_name:,
      first_names:,
      birthday_date:,
      gender:,
      user_id:
    }
  end

  let(:family_name) { 'Dupont' }
  let(:first_names) { %w[Jean Charlie] }
  let(:birthday_date) { '2000-01-02' }
  let(:gender) { 'M' }
  let(:user_id) { SecureRandom.uuid }

  let(:token) { 'dummy_oauth_token' }

  let!(:stubbed_request) do
    stub_request(:post, /#{Siade.credentials[:cnous_student_scholarship_civility_url]}/).with(
      body: {
        lastName: family_name,
        firstNames: 'Jean, Charlie',
        birthDate: '02/01/2000',
        civility: gender
      }.to_json,
      headers: {
        'Authorization' => "Bearer #{token}"
      }
    ).to_return(
      status: 200,
      body: Rails.root.join('spec/fixtures/payloads/cnous/student_scholarship_valid_response.json').read
    )
  end

  it { is_expected.to be_a_success }

  its(:response) { is_expected.to be_a(Net::HTTPOK) }

  it 'calls url with valid params and headers' do
    make_call

    expect(stubbed_request).to have_been_requested
  end
end
