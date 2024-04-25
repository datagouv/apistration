RSpec.describe INSEE::Successions, type: :retriever_organizer do
  subject { described_class.call(params:) }

  let(:params) do
    {
      siret:
    }
  end

  context 'with a valid siret' do
    let(:siret) { '30006240940040' }

    before { stub_insee_succession_make_request(siret:) }

    it { is_expected.to be_a_success }

    it 'retrieves the resource' do
      resource = subject.bundled_data.data

      expect(resource).to be_present
    end
  end
end
