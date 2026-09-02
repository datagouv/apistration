RSpec.describe MI::SIAF::Associations::ValidateParams, type: :validate_params do
  subject { described_class.call(params:) }

  let(:params) do
    {
      siren_or_siret_or_rna:
    }
  end

  context 'with a valid RNA id' do
    let(:siren_or_siret_or_rna) { siaf_association_rna_id }

    it { is_expected.to be_a_success }
  end

  context 'with a valid siren' do
    let(:siren_or_siret_or_rna) { siaf_association_siren }

    it { is_expected.to be_a_success }
  end

  context 'with a valid siret' do
    let(:siren_or_siret_or_rna) { siaf_association_siret }

    it { is_expected.to be_a_success }
  end

  context 'with an invalid RNA id' do
    let(:siren_or_siret_or_rna) { invalid_rna_id }

    it { is_expected.to be_a_failure }

    its(:errors) { is_expected.to include(instance_of(UnprocessableEntityError)) }
  end

  context 'with a blank param' do
    let(:siren_or_siret_or_rna) { '' }

    it { is_expected.to be_a_failure }

    its(:errors) { is_expected.to include(instance_of(UnprocessableEntityError)) }
  end
end
