RSpec.describe INPIError, type: :error do
  it_behaves_like 'a valid error' do
    let(:instance) { described_class.new(:incorrect_ids) }
  end
end
