RSpec.describe MESRI::StudentStatus::WithCivility, type: :retriever_organizer do
  describe '.call' do
    subject { described_class.call(params:) }

    let(:params) do
      {
        family_name:,
        first_name:,
        birth_date:,
        birth_place:,
        gender:,

        token_id: SecureRandom.uuid
      }
    end

    let(:family_name) { 'Dupont' }
    let(:first_name) { 'Jean' }
    let(:birth_date) { '2000-01-01' }
    let(:birth_place) { 'Paris' }
    let(:gender) { 'm' }

    describe 'happy path' do
      before do
        stub_request(:post, /#{Siade.credentials[:mesri_student_status_url]}/).to_return(
          status: 200,
          body: read_payload_file('mesri/student_status/with_civility_valid_response.json')
        )
      end

      it { is_expected.to be_a_success }

      it 'retrieves the resource' do
        resource = subject.bundled_data.data

        expect(resource).to be_present
      end
    end
  end
end
