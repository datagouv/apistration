RSpec.describe MESRI::StudentStatusWithINE, type: :retriever_organizer do
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
        stub_request(:get, /#{Siade.credentials[:mesri_student_status_url]}/).to_return(
          status: 200,
          body: File.read(Rails.root.join('spec/fixtures/payloads/mesri_student_status_valid_response.json'))
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
