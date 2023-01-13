RSpec.describe MESRI::StudentStatus::WithINE, type: :retriever_organizer do
  describe '.call' do
    subject { described_class.call(params:) }

    let(:params) do
      {
        ine: '1234567890G',
        token_id: SecureRandom.uuid
      }
    end

    describe 'happy path' do
      before do
        stub_request(:get, /#{Siade.credentials[:mesri_student_status_url]}/).to_return(
          status: 200,
          body: Rails.root.join('spec/fixtures/payloads/mesri/student_status/with_ine_valid_response.json').read
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
