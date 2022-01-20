RSpec.describe INPI::Marques, type: :retriever_organizer do
  subject { described_class.call(params: params) }

  let(:params) do
    {
      siren: siren,
      limit: 3
    }
  end

  context 'with valid siren', vcr: { cassette_name: 'inpi/marques/with_valid_siren' } do
    let(:siren) { valid_siren(:inpi) }

    it { is_expected.to be_a_success }

    its(:resource_collection) { is_expected.to be_present }
    its(:meta) { is_expected.to be_present }
  end

  context 'with siren not found', vcr: { cassette_name: 'inpi/marques/with_siren_not_found' } do
    let(:siren) { not_found_siren(:inpi) }

    it { is_expected.to be_a_failure }
  end

  context 'with invalid siren' do
    let(:siren) { 'invalid siren' }

    it { is_expected.to be_a_failure }
  end
end
