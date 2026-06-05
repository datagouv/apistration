RSpec.describe AdminActivity do
  it 'has a valid factory' do
    expect(build(:admin_activity)).to be_valid
  end

  it 'requires a name' do
    expect(build(:admin_activity, name: nil)).not_to be_valid
  end

  it 'requires a namespace' do
    expect(build(:admin_activity, namespace: nil)).not_to be_valid
  end
end
