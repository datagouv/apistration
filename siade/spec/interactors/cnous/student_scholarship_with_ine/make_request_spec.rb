RSpec.describe CNOUS::StudentScholarshipWithINE::MakeRequest, type: :make_request do
  subject(:make_call) { described_class.call(params:, token:) }

  let(:params) do
    {
      ine:
    }
  end

  let(:ine) { '1234567890G' }
  let(:token) { 'dummy_oauth_token' }

  let!(:stubbed_request) do
    stub_request(:get, "#{Siade.credentials[:cnous_student_scholarship_ine_url]}/#{ine}").with(
      headers: {
        'Authorization' => "Bearer #{token}"
      }
    ).to_return(
      status: 200,
      body: cnous_valid_payload('ine').to_json
    )
  end

  it_behaves_like 'a make request with working mocking_params'

  it { is_expected.to be_a_success }

  its(:response) { is_expected.to be_a(Net::HTTPOK) }

  it 'calls url with valid params and headers' do
    make_call

    expect(stubbed_request).to have_been_requested
  end
end
