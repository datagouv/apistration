RSpec.describe ConflictError, type: :error do
  it_behaves_like 'a valid error' do
    let(:instance) { described_class.new('CNOUS') }
  end
end
