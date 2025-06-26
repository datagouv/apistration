RSpec.describe MESRI::StudentStatus::WithINE::MakeRequest, type: :make_request do
  subject(:make_call) { described_class.call(params:) }

  let(:params) do
    {
      ine:,
      token_id:
    }
  end

  let(:ine) { '1234567890G' }
  let(:token_id) { SecureRandom.uuid }

  let!(:stubbed_request) do
    stub_request(:get, Siade.credentials[:mesri_student_status_url]).with(
      query: {
        INE: ine
      },
      headers: {
        'X-API-Key' => Siade.credentials[:mesri_student_status_token_with_ine],
        'X-Caller' => "DINUM - #{token_id}"
      }
    ).to_return(
      status: 200,
      body: read_payload_file('mesri/student_status/with_ine_valid_response.json')
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
