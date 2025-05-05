RSpec.describe SDH::ValidateIdentifiant, type: :validate_param_interactor do
  subject { described_class.call(params: { identifiant: }) }

  context 'when attribute is missing' do
    let(:identifiant) { nil }

    it { is_expected.to be_a_failure }

    its(:errors) { is_expected.to include(instance_of(UnprocessableEntityError)) }
  end

  context 'when attribute is present' do
    context 'when it is an integer' do
      let(:identifiant) { 12_345 }

      it { is_expected.to be_a_success }

      its(:errors) { is_expected.to be_empty }
    end

    context 'when it is not an integer' do
      let(:identifiant) { 'nope' }

      it { is_expected.to be_a_failure }

      its(:errors) { is_expected.to include(instance_of(UnprocessableEntityError)) }
    end
  end
end
