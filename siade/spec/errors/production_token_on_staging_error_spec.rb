RSpec.describe ProductionTokenOnStagingError, type: :error do
  it_behaves_like 'a valid error'

  it 'points to the public staging token' do
    expect(described_class.new.detail).to include('https://github.com/datagouv/apistration/blob/develop/mocks/tokens/default')
  end
end
