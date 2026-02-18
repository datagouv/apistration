RSpec.describe MEN::ScolaritesPerimetre::Validators::CommuneValidator do
  describe '.valid?' do
    subject { described_class.valid?(values) }

    context 'with valid codes' do
      %w[72312 2A004 2B033 75056 01001 97105].each do |code|
        context "when value is #{code}" do
          let(:values) { [code] }

          it { is_expected.to be true }
        end
      end
    end

    context 'with invalid codes' do
      {
        '7231' => 'too short (4 chars)',
        '723121' => 'too long (6 chars)',
        '2Z004' => 'invalid letter',
        '' => 'empty string',
        'ABCDE' => 'all letters',
        '20000' => 'starts with 20'
      }.each do |code, reason|
        context "when value is #{code} (#{reason})" do
          let(:values) { [code] }

          it { is_expected.to be false }
        end
      end
    end

    context 'with mix of valid and invalid' do
      let(:values) { %w[75056 ABCDE] }

      it { is_expected.to be false }
    end
  end
end
