RSpec.describe BDFError, type: :error do
  it_behaves_like 'a valid error' do
    let(:instance) { described_class.new(:bdd_error) }
  end
end
