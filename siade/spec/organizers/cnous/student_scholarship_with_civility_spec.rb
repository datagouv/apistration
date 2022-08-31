RSpec.describe CNOUS::StudentScholarshipWithCivility, type: :retriever_organizer do
  describe '.call' do
    subject { described_class.call(params:) }

    let(:params) do
      {
        family_name:,
        first_names:,
        birthday_date:,
        birth_place:,
        gender:,

        user_id: SecureRandom.uuid
      }
    end

    let(:family_name) { 'Dupont' }
    let(:first_names) { %w[Jean Charlie] }
    let(:birthday_date) { '2000-01-01' }
    let(:birth_place) { 'Paris' }
    let(:gender) { 'M' }

    describe 'happy path' do
      before do
        mock_cnous_authenticate
        mock_cnous_valid_call('civility')
      end

      it { is_expected.to be_a_success }

      it 'retrieves the resource' do
        resource = subject.bundled_data.data

        expect(resource).to be_present
      end
    end
  end
end
