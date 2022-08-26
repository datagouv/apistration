RSpec.describe CNOUS::StudentScholarshipWithINE, type: :retriever_organizer do
  describe '.call' do
    subject { described_class.call(params:) }

    let(:params) do
      {
        ine: '1234567890G',
        user_id: SecureRandom.uuid
      }
    end

    describe 'happy path' do
      before do
        mock_cnous_authenticate
        mock_cnous_student_scholarship_ine_valid_call
      end

      it { is_expected.to be_a_success }

      it 'retrieves the resource' do
        resource = subject.bundled_data.data

        expect(resource).to be_present
      end
    end
  end
end
