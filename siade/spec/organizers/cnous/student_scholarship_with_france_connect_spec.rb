RSpec.describe CNOUS::StudentScholarshipWithFranceConnect, type: :retriever_organizer do
  describe '.call' do
    subject { described_class.call(params:) }

    let(:params) { default_france_connect_identity_attributes.merge(user_id: SecureRandom.uuid) }

    describe 'happy path' do
      before do
        mock_cnous_authenticate
        mock_cnous_valid_call('france_connect')
      end

      it { is_expected.to be_a_success }

      it 'retrieves the resource' do
        resource = subject.bundled_data.data

        expect(resource).to be_present
      end
    end
  end
end
