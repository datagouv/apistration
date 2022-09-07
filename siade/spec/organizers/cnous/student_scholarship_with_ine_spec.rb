RSpec.describe CNOUS::StudentScholarshipWithINE, type: :retriever_organizer do
  describe '.call' do
    subject { described_class.call(params:) }

    let(:params) do
      {
        ine: '1234567890G'
      }
    end

    describe 'happy path' do
      before do
        mock_cnous_authenticate
        mock_cnous_valid_call('ine')
      end

      it { is_expected.to be_a_success }

      it 'retrieves the resource' do
        resource = subject.bundled_data.data

        expect(resource).to be_present
      end
    end
  end
end
