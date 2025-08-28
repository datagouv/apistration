RSpec.describe SDH::StatutSportif, type: :retriever_organizer do
  subject { described_class.call(params:) }

  let(:params) do
    {
      identifiant: '123456789'
    }
  end

  before do
    stub_sdh_authenticate
    stub_sdh_statut_sportif_valid('123456789')
  end

  describe 'happy path' do
    it { is_expected.to be_a_success }

    it 'retrieves the resource' do
      resource = subject.bundled_data.data

      expect(resource).to be_present
    end
  end
end
