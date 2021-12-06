RSpec.describe INPI::Brevets, type: :retriever_organizer do
  subject { described_class.call(params: params) }

  let(:params) do
    {
      siren: siren,
      limit: 3
   }
  end

  context 'with valid siren', vcr: { cassette_name: 'inpi/brevets/with_valid_siren' } do
    let(:siren) { valid_siren(:inpi) }

    it { is_expected.to be_a_success }

    its(:resource_collection) { is_expected.to be_present }
    its(:meta) { is_expected.to be_present }
  end

  context 'with siren not found', vcr: { cassette_name: 'inpi/brevets/with_siren_not_found' } do
    let(:siren) { not_found_siren(:inpi) }

    it { is_expected.to be_a_failure }
  end

  context 'with invalid siren', vcr: { cassette_name: 'inpi/brevets/with_invalid_siren' } do
    let(:siren) { 'invalid siren' }

    it { is_expected.to be_a_failure }
  end
end
