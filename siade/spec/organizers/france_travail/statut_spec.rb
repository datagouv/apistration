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

    describe 'happy path', vcr: { cassette_name: 'pole_emploi/oauth2' } do
      before do
        stub_request(:post, Siade.credentials[:pole_emploi_status_url]).and_return(
          status: 200,
          body: read_payload_file('pole_emploi/statut/valid.json')
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
