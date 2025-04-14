RSpec.describe DSNJAgeIrrelevantError, type: :error do
  it_behaves_like 'a valid error' do
    let(:instance) { described_class.new(:irrelevant_age) }
  end
end
