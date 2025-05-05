RSpec.describe SDH::StatutSportif, type: :retriever_organizer do
  subject { described_class.call(params:) }

  let(:params) do
    {
      identifiant:
    }
  end

  before do
    stub_sdh_authenticate
    stub_sdh_statut_sportif_valid
  end

  describe 'happy path' do
    before { pending 'Implement endpoint' }

    it { is_expected.to be_a_success }

    it 'retrieves the resource' do
      resource = subject.bundled_data.data

      expect(resource).to be_present
    end
  end
end
