RSpec.shared_examples 'retriever organizer' do
  it 'inherits from RetrieverOrganizer' do
    expect(described_class < RetrieverOrganizer).to be_truthy
  end
end
