RSpec.describe INSEEError, type: :error do
  it_behaves_like 'a valid error' do
    let(:instance) { described_class.new(:more_than_one_siege) }
  end
end
