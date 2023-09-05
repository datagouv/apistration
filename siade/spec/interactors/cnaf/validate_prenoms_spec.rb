RSpec.describe CNAF::ValidatePrenoms, type: :validate_param_interactor do
  subject do
    described_class.call(params: {
      prenoms:
    })
  end

  context 'when prenoms is an array' do
    let(:prenoms) { %w[Jean Paul] }

    it { is_expected.to be_a_success }

    its(:errors) { is_expected.to be_empty }
  end

  context 'when prenoms is nil' do
    let(:prenoms) { nil }

    it { is_expected.to be_a_success }

    its(:errors) { is_expected.to be_empty }
  end

  context 'when prenoms is an empty array' do
    let(:prenoms) { [] }

    it { is_expected.to be_a_failure }

    its(:errors) { is_expected.to include(instance_of(UnprocessableEntityError)) }
  end

  context 'when prenoms is not an array' do
    let(:prenoms) { 'jean' }

    it { is_expected.to be_a_failure }

    its(:errors) { is_expected.to include(instance_of(UnprocessableEntityError)) }
  end
end
