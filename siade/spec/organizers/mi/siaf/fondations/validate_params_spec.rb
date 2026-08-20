RSpec.describe MI::SIAF::Fondations::ValidateParams, type: :validate_params do
  subject { described_class.call(params:) }

  let(:params) do
    {
      siren_or_siret_or_rnf:
    }
  end

  context 'with a valid RNF id' do
    let(:siren_or_siret_or_rnf) { valid_rnf_id }

    it { is_expected.to be_a_success }
  end

  context 'with a lowercase RNF id' do
    let(:siren_or_siret_or_rnf) { valid_rnf_id.downcase }

    it { is_expected.to be_a_success }
  end

  context 'with a valid siren' do
    let(:siren_or_siret_or_rnf) { fondation_siren }

    it { is_expected.to be_a_success }
  end

  context 'with a valid siret' do
    let(:siren_or_siret_or_rnf) { fondation_siret }

    it { is_expected.to be_a_success }
  end

  context 'with an invalid RNF id' do
    let(:siren_or_siret_or_rnf) { invalid_rnf_id }

    it { is_expected.to be_a_failure }

    its(:errors) { is_expected.to include(instance_of(UnprocessableEntityError)) }
  end

  context 'with a blank param' do
    let(:siren_or_siret_or_rnf) { '' }

    it { is_expected.to be_a_failure }

    its(:errors) { is_expected.to include(instance_of(UnprocessableEntityError)) }
  end
end
