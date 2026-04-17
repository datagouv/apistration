RSpec.describe ApiGouvCommons::UserAgent do
  it 'builds the §10 format' do
    ua = described_class.build(product: 'api-entreprise-ruby', version: '1.2.3')
    expect(ua).to eq('api-entreprise-ruby/1.2.3 (+https://github.com/datagouv/apistration)')
  end

  it 'appends an optional suffix' do
    ua = described_class.build(product: 'api-particulier-ruby', version: '0.1.0', suffix: 'MyApp/4.5')
    expect(ua).to eq('api-particulier-ruby/0.1.0 (+https://github.com/datagouv/apistration) MyApp/4.5')
  end
end
