RSpec.describe MEN::Scolarites::Validators::RegionValidator do
  describe '.valid?' do
    subject { described_class.valid?(values) }

    context 'with valid codes' do
      %w[01 10 18].each do |code|
        context "when value is #{code}" do
          let(:values) { [code] }

          it { is_expected.to be true }
        end
      end
    end

    context 'with invalid codes' do
      {
        '99' => 'not in BCN list',
        '1' => 'too short (1 char)',
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
      let(:values) { %w[11 99] }

      it { is_expected.to be false }
    end
  end
end
