RSpec.describe MEN::Scolarites::ValidateSearchParams, type: :validate_param_interactor do
  describe '.call' do
    subject { described_class.call(params:) }

    let(:params) do
      {
        code_etablissement:,
        degre_etablissement:,
        codes_bcn_departements:,
        codes_bcn_regions:
      }
    end

    let(:code_etablissement) { nil }
    let(:degre_etablissement) { nil }
    let(:codes_bcn_departements) { nil }
    let(:codes_bcn_regions) { nil }

    context 'with valid code_etablissement' do
      let(:code_etablissement) { '0511474A' }

      it { is_expected.to be_a_success }
    end

    context 'with valid perimetre' do
      let(:degre_etablissement) { '2D' }
      let(:codes_bcn_regions) { %w[11] }

      it { is_expected.to be_a_success }

      it 'sets perimetre_type on context' do
        expect(subject.perimetre_type).to eq('region')
      end
    end

    context 'with both code_etablissement and perimetre' do
      let(:code_etablissement) { '0511474A' }
      let(:codes_bcn_regions) { %w[11] }

      it { is_expected.to be_a_failure }

      it 'returns mutual exclusivity error' do
        error = subject.errors.find { |e| e.code == '00419' }
        expect(error).to be_present
      end
    end

    context 'with neither code_etablissement nor perimetre' do
      it { is_expected.to be_a_failure }

      it 'returns code_etablissement error' do
        error = subject.errors.find { |e| e.code == '00410' }
        expect(error).to be_present
      end
    end
  end
end
