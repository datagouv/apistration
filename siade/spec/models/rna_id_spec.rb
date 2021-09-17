RSpec.describe RNAId do
  it 'to_s' do
    expect(described_class.new(valid_rna_id).to_s).to eq(valid_rna_id)
  end
end
