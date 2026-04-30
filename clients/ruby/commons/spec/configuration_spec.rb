RSpec.describe ApiGouvCommons::Configuration do
  let(:base_urls) do
    {
      ApiGouvCommons::Configuration::PRODUCTION => 'https://prod.test',
      ApiGouvCommons::Configuration::STAGING => 'https://staging.test'
    }
  end

  it 'defaults to production and builds a BearerToken strategy from a token' do
    config = described_class.new(base_urls: base_urls, token: 'abc')
    expect(config.production?).to be true
    expect(config.base_url).to eq('https://prod.test')
    expect(config.auth_strategy).to be_a(ApiGouvCommons::Auth::BearerToken)
  end

  it 'resolves staging' do
    config = described_class.new(base_urls: base_urls, token: 'abc', environment: :staging)
    expect(config.base_url).to eq('https://staging.test')
    expect(config.staging?).to be true
  end

  it 'accepts a base_url override' do
    config = described_class.new(base_urls: base_urls, token: 'x', base_url: 'https://custom.test')
    expect(config.base_url).to eq('https://custom.test')
  end

  it 'rejects unknown environments' do
    expect { described_class.new(base_urls: base_urls, token: 'x', environment: :dev) }
      .to raise_error(ArgumentError, /environment must be/)
  end

  it 'is frozen after construction' do
    config = described_class.new(base_urls: base_urls, token: 'x')
    expect(config).to be_frozen
  end

  describe '#with' do
    it 'returns a new instance without mutating the source' do
      original = described_class.new(base_urls: base_urls, token: 'x')
      copy = original.with(environment: :staging)
      expect(copy).not_to equal(original)
      expect(original.staging?).to be false
      expect(copy.staging?).to be true
    end

    it 'is aliased as copy' do
      original = described_class.new(base_urls: base_urls, token: 'x')
      expect(original.method(:copy)).to eq(original.method(:with))
    end
  end

  it 'defaults timeouts to 5 s / 30 s' do
    config = described_class.new(base_urls: base_urls, token: 'x')
    expect(config.open_timeout).to eq(5)
    expect(config.read_timeout).to eq(30)
  end

  it 'accepts a preconstructed auth_strategy and ignores token' do
    strategy = ApiGouvCommons::Auth::BearerToken.new('zzz')
    config = described_class.new(base_urls: base_urls, auth_strategy: strategy)
    expect(config.auth_strategy).to equal(strategy)
  end
end
