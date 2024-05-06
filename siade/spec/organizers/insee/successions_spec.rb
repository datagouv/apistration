RSpec.describe INSEE::Successions, type: :retriever_organizer do
  subject { described_class.call(params:) }

  let(:params) do
    {
      siret:
    }
  end

  context 'with a valid siret' do
    let(:siret) { sirets_insee_v3[:successions] }

    before do
      stub_insee_authenticate
      stub_insee_successions_make_request(siret:)
    end

    it { is_expected.to be_a_success }

    it 'retrieves the resource' do
      resource = subject.bundled_data.data

      expect(resource).to be_present
    end
  end
end
