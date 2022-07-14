RSpec.describe INPI::Modeles, type: :retriever_organizer do
  subject { described_class.call(params:) }

  let(:params) do
    {
      siren:,
      limit: 3
    }
  end

  context 'with valid siren', vcr: { cassette_name: 'inpi/modeles/with_valid_siren' } do
    let(:siren) { valid_siren(:inpi) }

    it { is_expected.to be_a_success }

    it 'retrieves the resource collection' do
      resource_collection = subject.bundled_data.data

      expect(resource_collection).to be_present
    end

    it 'has meta' do
      meta = subject.bundled_data.context

      expect(meta).to be_present
    end
  end

  context 'with siren not found', vcr: { cassette_name: 'inpi/modeles/not_found_siren' } do
    let(:siren) { not_found_siren(:inpi) }

    it { is_expected.to be_a_failure }
  end

  context 'with invalid siren' do
    let(:siren) { 'invalid siren' }

    it { is_expected.to be_a_failure }
  end
end
