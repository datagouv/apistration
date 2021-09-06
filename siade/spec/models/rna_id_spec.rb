RSpec.describe RNAId do
  it 'to_s' do
    expect(RNAId.new(valid_rna_id).to_s).to eq(valid_rna_id)
  end
end
