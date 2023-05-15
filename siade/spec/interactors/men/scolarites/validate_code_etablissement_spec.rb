RSpec.describe MEN::Scolarites::ValidateCodeEtablissement, type: :validate_param_interactor do
  describe '.call' do
    subject { described_class.call(params:) }

    let(:params) do
      {
        code_etablissement:
      }
    end

    context 'when valid' do
      let(:code_etablissement) { '0890003V' }

      it { is_expected.to be_a_success }
    end

    context 'when invalid' do
      let(:code_etablissement) { '2014-2015' }

      it { is_expected.to be_a_failure }

      its(:errors) { is_expected.to be_present }
    end

    context 'when it is nil' do
      let(:code_etablissement) { nil }

      it { is_expected.to be_a_failure }

      its(:errors) { is_expected.to be_present }
    end

    context 'when it is empty' do
      let(:code_etablissement) { '' }

      it { is_expected.to be_a_failure }

      its(:errors) { is_expected.to be_present }
    end
  end
end
