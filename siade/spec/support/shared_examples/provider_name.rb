RSpec.shared_examples 'has a provider_name' do
  it 'has a provider_name instance method defined in this class' do
    expect(described_class.instance_methods(false)).to include(:provider_name)
  end
end
