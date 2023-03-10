RSpec.describe GIPMDS::EffectifsAnnuelsEntreprise::ValidateParams, type: :validate_params do
  subject { described_class.call(params:) }

  let(:params) do
    {
      siren:,
      year:
    }
  end

  let(:siren) { valid_siren }
  let(:year) { '1990' }

  context 'with valid params' do
    it { is_expected.to be_a_success }
  end

  context 'with invalid siren' do
    let(:siren) { invalid_siren }

    it { is_expected.to be_a_failure }
  end

  context 'with an invalid year' do
    let(:year) { 'not a year' }

    it { is_expected.to be_a_failure }
  end
end
