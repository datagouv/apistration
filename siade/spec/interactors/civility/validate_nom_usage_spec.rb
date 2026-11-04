RSpec.describe Civility::ValidateNomUsage, type: :validate_params do
  subject { described_class.call(params: { nom_usage: }) }

  context 'when the nom d’usage is not provided' do
    let(:nom_usage) { nil }

    it { is_expected.to be_a_success }
  end

  context 'when the nom d’usage is an empty string' do
    let(:nom_usage) { '' }

    it { is_expected.to be_a_success }
  end

  context 'when the nom d’usage is a valid name' do
    let(:nom_usage) { "DE L'ÉTANG" }

    it { is_expected.to be_a_success }
  end

  [false, {}, [], [''], { 'a' => 'DUPONT' }].each do |value|
    context "when the nom d’usage is #{value.inspect}, which is not a string" do
      let(:nom_usage) { value }

      it { is_expected.to be_a_failure }
    end
  end
end
