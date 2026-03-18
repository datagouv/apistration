RSpec.describe RNAError, type: :error do
  it_behaves_like 'a valid error' do
    let(:instance) { described_class.new(:incorrect_xml) }
  end
end
