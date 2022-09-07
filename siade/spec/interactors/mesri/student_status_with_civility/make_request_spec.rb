RSpec.describe MESRI::StudentStatusWithCivility::MakeRequest, type: :make_request do
  subject(:make_call) { described_class.call(params:) }

  let(:params) do
    {
      family_name:,
      first_name:,
      birthday_date:,
      gender:,
      user_id:
    }
  end

  let(:family_name) { 'Dupont' }
  let(:first_name) { 'Jean' }
  let(:birthday_date) { '2000-01-01' }
  let(:gender) { 'm' }
  let(:user_id) { SecureRandom.uuid }

  let!(:stubbed_request) do
    stub_request(:post, Siade.credentials[:mesri_student_status_url]).with(
      body: {
        nomFamille: family_name,
        prenom1: first_name,
        dateNaissance: birthday_date,
        sexe: '1'
      }.to_json,
      headers: {
        'X-API-Key' => Siade.credentials[:mesri_student_status_token_with_civility],
        'X-Caller' => "DINUM - #{user_id}"
      }
    ).to_return(
      status: 200,
      body: File.read(Rails.root.join('spec/fixtures/payloads/mesri_student_status_with_civility_valid_response.json'))
    )
  end

  it { is_expected.to be_a_success }

  its(:response) { is_expected.to be_a(Net::HTTPOK) }

  it 'calls url with valid params and headers' do
    make_call

    expect(stubbed_request).to have_been_requested
  end
end
