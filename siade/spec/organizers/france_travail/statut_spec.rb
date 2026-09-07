RSpec.describe FranceTravail::Statut, type: :retriever_organizer do
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

    describe 'happy path' do
      before do
        stub_france_travail_authenticate

        stub_request(:post, Siade.credentials[:france_travail_status_url]).and_return(
          status: 200,
          body: read_payload_file('france_travail/statut/valid.json')
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
