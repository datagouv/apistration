RSpec.describe MESRI::StudentStatus::WithCivility::MakeRequest, type: :make_request do
  subject(:make_call) { described_class.call(params:) }

  context 'with a birth place empty' do
    let(:params) do
      {
        family_name:,
        first_name:,
        birth_date:,
        birth_place:,
        gender:,
        token_id:
      }
    end

    let(:family_name) { 'Dupont' }
    let(:first_name) { 'Jean' }
    let(:birth_date) { '2000-01-01' }
    let(:birth_place) { '' }
    let(:gender) { 'M' }
    let(:token_id) { SecureRandom.uuid }

    let!(:stubbed_request) do
      stub_request(:post, Siade.credentials[:mesri_student_status_url]).with(
        body: {
          nomFamille: family_name,
          prenom1: first_name,
          dateNaissance: birth_date,
          sexe: '1'
        }.to_json,
        headers: {
          'X-API-Key' => Siade.credentials[:mesri_student_status_token_with_civility],
          'X-Caller' => "DINUM - #{token_id}"
        }
      ).to_return(
        status: 200,
        body: read_payload_file('mesri/student_status/with_civility_valid_response.json')
      )
    end

    it { is_expected.to be_a_success }

    its(:response) { is_expected.to be_a(Net::HTTPOK) }

    it 'calls url with valid params, by removing empty birth place and headers' do
      make_call

      expect(stubbed_request).to have_been_requested
    end
  end

  context 'without birth place' do
    let(:params) do
      {
        family_name:,
        first_name:,
        birth_date:,
        gender:,
        token_id:
      }
    end

    let(:family_name) { 'Dupont' }
    let(:first_name) { 'Jean' }
    let(:birth_date) { '2000-01-01' }
    let(:gender) { 'm' }
    let(:token_id) { SecureRandom.uuid }

    let!(:stubbed_request) do
      stub_request(:post, Siade.credentials[:mesri_student_status_url]).with(
        body: {
          nomFamille: family_name,
          prenom1: first_name,
          dateNaissance: birth_date,
          sexe: '1'
        }.to_json,
        headers: {
          'X-API-Key' => Siade.credentials[:mesri_student_status_token_with_civility],
          'X-Caller' => "DINUM - #{token_id}"
        }
      ).to_return(
        status: 200,
        body: read_payload_file('mesri/student_status/with_civility_valid_response.json')
      )
    end

    it { is_expected.to be_a_success }

    its(:response) { is_expected.to be_a(Net::HTTPOK) }

    it 'calls url with valid params and headers' do
      make_call

      expect(stubbed_request).to have_been_requested
    end
  end
end
