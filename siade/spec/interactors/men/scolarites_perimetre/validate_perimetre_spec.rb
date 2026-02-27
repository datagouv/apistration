RSpec.describe MEN::ScolaritesPerimetre::ValidatePerimetre, type: :validate_param_interactor do
  describe '.call' do
    subject { described_class.call(params:) }

    let(:params) do
      {
        codes_bcn_departements:,
        codes_bcn_regions:
      }
    end

    let(:codes_bcn_departements) { nil }
    let(:codes_bcn_regions) { nil }

    context 'with one departement perimetre' do
      let(:codes_bcn_departements) { %w[075] }

      it { is_expected.to be_a_success }

      it 'sets perimetre_type' do
        expect(subject.perimetre_type).to eq('departement')
      end
    end

    context 'with one region perimetre' do
      let(:codes_bcn_regions) { %w[11] }

      it { is_expected.to be_a_success }

      it 'sets perimetre_type' do
        expect(subject.perimetre_type).to eq('region')
      end

      it 'sets perimetre_valeurs' do
        expect(subject.perimetre_valeurs).to eq(%w[11])
      end
    end

    context 'with no perimetre provided' do
      it { is_expected.to be_a_failure }

      its(:errors) { is_expected.to include(instance_of(UnprocessableEntityError)) }
    end

    context 'with two perimetres provided' do
      let(:codes_bcn_departements) { %w[075] }
      let(:codes_bcn_regions) { %w[11] }

      it { is_expected.to be_a_failure }

      its(:errors) { is_expected.to include(instance_of(UnprocessableEntityError)) }
    end

    context 'with empty array perimetre' do
      let(:codes_bcn_regions) { [] }

      it { is_expected.to be_a_failure }
    end

    context 'with array containing blank value' do
      let(:codes_bcn_regions) { [''] }

      it { is_expected.to be_a_failure }
    end

    context 'with invalid departement code format' do
      let(:codes_bcn_departements) { %w[999] }

      it { is_expected.to be_a_failure }

      it 'returns codes_bcn_departements error' do
        error = subject.errors.find { |e| e.code == '00416' }
        expect(error).to be_present
      end
    end

    context 'with invalid region code format' do
      let(:codes_bcn_regions) { %w[99] }

      it { is_expected.to be_a_failure }

      it 'returns codes_bcn_regions error' do
        error = subject.errors.find { |e| e.code == '00417' }
        expect(error).to be_present
      end
    end
  end
end
