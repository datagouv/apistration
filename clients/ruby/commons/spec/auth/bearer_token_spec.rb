RSpec.describe ApiGouvCommons::Auth::BearerToken do
  it 'sets the Authorization header' do
    request = Struct.new(:headers).new({})
    described_class.new('abc').apply(request)
    expect(request.headers['Authorization']).to eq('Bearer abc')
  end

  it 'rejects empty tokens' do
    expect { described_class.new('') }.to raise_error(ArgumentError)
    expect { described_class.new(nil) }.to raise_error(ArgumentError)
  end
end
