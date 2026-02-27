RSpec.describe MEN::Scolarites::Validators::DepartementValidator do
  describe '.valid?' do
    subject { described_class.valid?(values) }

    context 'with valid codes' do
      %w[069 02A 971].each do |code|
        context "when value is #{code}" do
          let(:values) { [code] }

          it { is_expected.to be true }
        end
      end
    end

    context 'with invalid codes' do
      {
        '999' => 'not in BCN list',
        '69' => 'too short (2 chars)',
        'ABC' => 'letters only',
        '' => 'empty string'
      }.each do |code, reason|
        context "when value is #{code} (#{reason})" do
          let(:values) { [code] }

          it { is_expected.to be false }
        end
      end
    end

    context 'with mix of valid and invalid' do
      let(:values) { %w[069 999] }

      it { is_expected.to be false }
    end
  end
end
