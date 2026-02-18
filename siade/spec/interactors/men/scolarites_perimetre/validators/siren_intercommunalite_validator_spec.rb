RSpec.describe MEN::ScolaritesPerimetre::Validators::SirenIntercommunaliteValidator do
  describe '.valid?' do
    subject { described_class.valid?(values) }

    context 'with valid SIREN' do
      let(:values) { %w[200054781] }

      it { is_expected.to be true }
    end

    context 'with invalid codes' do
      {
        '12345678' => 'too short (8 chars)',
        '1234567890' => 'too long (10 chars)',
        '123456789' => 'Luhn check fails'
      }.each do |code, reason|
        context "when value is #{code} (#{reason})" do
          let(:values) { [code] }

          it { is_expected.to be false }
        end
      end
    end

    context 'with mix of valid and invalid' do
      let(:values) { %w[200054781 123456789] }

      it { is_expected.to be false }
    end
  end
end
