RSpec.describe CNOUS::StudentScholarshipWithCivility, type: :retriever_organizer do
  describe '.call' do
    subject { described_class.call(params:) }

    let(:params) do
      {
        family_name:,
        first_names:,
        birthday_date:,
        birthday_place:,
        gender:,

        user_id: SecureRandom.uuid
      }
    end

    let(:family_name) { 'Dupont' }
    let(:first_names) { 'Jean Charlie' }
    let(:birthday_date) { '2000-01-01' }
    let(:birthday_place) { 'Paris' }
    let(:gender) { 'M' }

    describe 'happy path' do
      before do
        mock_cnous_authenticate

        stub_request(:post, /#{Siade.credentials[:cnous_student_scholarship_civility_url]}/).to_return(
          status: 200,
          body: File.read(Rails.root.join('spec/fixtures/payloads/cnous_student_scholarship_valid_response.json'))
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
