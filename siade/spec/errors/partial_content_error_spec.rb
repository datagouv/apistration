RSpec.describe PartialContentError, type: :error do
  it_behaves_like 'a valid error' do
    let(:instance) { described_class.new(:whatever, 'INSEE') }
  end
end
