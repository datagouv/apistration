RSpec.describe MEN::Scolarites::ValidateDegreEtablissement, type: :validate_param_interactor do
  describe '.call' do
    subject { described_class.call(params:) }

    let(:params) do
      {
        degre_etablissement:
      }
    end

    context 'when valid with 1D' do
      let(:degre_etablissement) { '1D' }

      it { is_expected.to be_a_success }
    end

    context 'when valid with 2D' do
      let(:degre_etablissement) { '2D' }

      it { is_expected.to be_a_success }
    end

    context 'when invalid' do
      let(:degre_etablissement) { '3D' }

      it { is_expected.to be_a_failure }

      its(:errors) { is_expected.to include(instance_of(UnprocessableEntityError)) }
    end

    context 'when lowercase' do
      let(:degre_etablissement) { '1d' }

      it { is_expected.to be_a_failure }

      its(:errors) { is_expected.to include(instance_of(UnprocessableEntityError)) }
    end

    context 'when nil' do
      let(:degre_etablissement) { nil }

      it { is_expected.to be_a_failure }

      its(:errors) { is_expected.to include(instance_of(UnprocessableEntityError)) }
    end

    context 'when empty' do
      let(:degre_etablissement) { '' }

      it { is_expected.to be_a_failure }

      its(:errors) { is_expected.to include(instance_of(UnprocessableEntityError)) }
    end
  end
end
