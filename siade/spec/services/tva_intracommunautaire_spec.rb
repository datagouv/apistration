RSpec.describe TVAIntracommunautaire, type: :service do
  subject { described_class.new(siren).perform }

  let(:siren) { '404833048' }

  it { is_expected.to eq('FR83404833048') }
end
