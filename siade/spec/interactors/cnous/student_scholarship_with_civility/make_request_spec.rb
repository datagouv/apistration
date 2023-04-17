RSpec.describe CNOUS::StudentScholarshipWithCivility::MakeRequest, type: :make_request do
  subject(:make_call) { described_class.call(params:, token:) }

  let(:params) do
    {
      family_name:,
      first_names:,
      birth_date:,
      birth_place:,
      gender:
    }
  end

  let(:family_name) { 'Dupont' }
  let(:first_names) { %w[Jean Charlie] }
  let(:birth_date) { '2000-01-02' }
  let(:birth_place) { 'Angers' }
  let(:gender) { 'm' }

  let(:token) { 'dummy_oauth_token' }

  context 'with all params' do
    let!(:stubbed_request) do
      stub_request(:post, /#{Siade.credentials[:cnous_student_scholarship_civility_url]}/).with(
        body: {
          lastName: family_name,
          firstNames: 'Jean, Charlie',
          birthDate: '02/01/2000',
          birthPlace: birth_place,
          civility: 'M'
        }.to_json,
        headers: {
          'Authorization' => "Bearer #{token}"
        }
      ).to_return(
        status: 200,
        body: cnous_valid_payload('civility').to_json
      )
    end

    it { is_expected.to be_a_success }

    its(:response) { is_expected.to be_a(Net::HTTPOK) }

    it 'calls url with valid params and headers' do
      make_call

      expect(stubbed_request).to have_been_requested
    end
  end

  context 'without birth place' do
    let(:birth_place) { nil }

    before do
      stub_request(:post, /#{Siade.credentials[:cnous_student_scholarship_civility_url]}/).with(
        body: {
          lastName: family_name,
          firstNames: 'Jean, Charlie',
          birthDate: '02/01/2000',
          civility: 'M'
        }.to_json,
        headers: {
          'Authorization' => "Bearer #{token}"
        }
      ).to_return(
        status: 200,
        body: cnous_valid_payload('civility').to_json
      )
    end

    it { is_expected.to be_a_success }

    its(:response) { is_expected.to be_a(Net::HTTPOK) }
  end
end
