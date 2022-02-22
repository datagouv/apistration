RSpec.describe GoneError, type: :error do
  it_behaves_like 'a valid error' do
    let(:instance) { described_class.new('INSEE', 'whatever') }
  end
end
