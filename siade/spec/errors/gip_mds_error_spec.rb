RSpec.describe GIPMDSError, type: :error do
  it_behaves_like 'a valid error' do
    let(:instance) { described_class.new(:ko_technique) }
  end
end
