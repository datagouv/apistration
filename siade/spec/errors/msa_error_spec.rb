RSpec.describe MSAError, type: :error do
  it_behaves_like 'a valid error' do
    let(:instance) { described_class.new(:qf_calculation_impossible) }
  end
end
