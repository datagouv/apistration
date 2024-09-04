RSpec.describe FranceTravail::Indemnites, type: :retriever_organizer do
  subject { described_class.call(params:) }

  describe '.call' do
    subject { described_class.call(params:) }

    let(:params) do
      {
        identifiant_pole_emploi:,
        user_id:
      }
    end

    let(:identifiant_pole_emploi) { 'whatever' }
    let(:user_id) { SecureRandom.uuid }

    describe 'happy path', vcr: { cassette_name: 'pole_emploi/oauth2' } do
      before do
        stub_request(:get, "#{Siade.credentials[:pole_emploi_indemnites_url]}?loginMnemotechnique=#{identifiant_pole_emploi}")
          .to_return(
            status: 200,
            body: read_payload_file('pole_emploi/indemnites/valid.json')
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
