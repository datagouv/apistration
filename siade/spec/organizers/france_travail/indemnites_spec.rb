RSpec.describe FranceTravail::Indemnites, type: :retriever_organizer do
  subject { described_class.call(params:) }

  describe '.call' do
    subject { described_class.call(params:) }

    let(:params) do
      {
        identifiant:,
        user_id:
      }
    end

    let(:identifiant) { 'whatever' }
    let(:user_id) { SecureRandom.uuid }

    describe 'happy path', vcr: { cassette_name: 'france_travail/oauth2' } do
      before do
        stub_france_travail_indemnites_valid(identifiant:)
      end

      it { is_expected.to be_a_success }

      it 'retrieves the resource' do
        resource = subject.bundled_data.data

        expect(resource).to be_present
      end
    end
  end
end
