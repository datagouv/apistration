RSpec.describe DataSubvention::Subventions, type: :retriever_organizer do
  subject { described_class.call(params:) }

  let(:params) do
    {
      siren_or_siret_or_rna: siren
    }
  end

  let(:siren) { valid_siren }

  describe 'happy path' do
    before do
      stub_datasubvention_subventions_authenticate
      stub_datasubvention_subventions_valid(id: siren)
    end

    it { is_expected.to be_a_success }

    it 'retrieves the resource' do
      resource = subject.bundled_data.data

      expect(resource).to be_present
    end
  end
end
