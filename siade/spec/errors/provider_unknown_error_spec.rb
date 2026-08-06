RSpec.describe ProviderUnknownError, type: :error do
  it_behaves_like 'a valid error' do
    let(:instance) { described_class.new('INSEE') }
  end

  it 'defaults to subcode 999' do
    expect(described_class.new('INSEE').subcode).to eq('999')
  end

  context 'with a custom subcode' do
    let(:instance) { described_class.new('CNAV', subcode: '998') }

    it 'uses the given subcode' do
      expect(instance.subcode).to eq('998')
    end

    it 'resolves the title for that subcode' do
      expect(instance.title).to eq('Réponse inconnue du fournisseur de données')
    end
  end
end
