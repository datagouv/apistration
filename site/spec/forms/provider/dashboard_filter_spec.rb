RSpec.describe Provider::DashboardFilter do
  let(:provider) { instance_double(APIEntreprise::Provider, routes_or_uid_to_match: ['insee']) }

  it 'defaults date range to last 7 days' do
    filter = described_class.new(provider, 'entreprise')

    expect(filter.date_from).to eq(7.days.ago.to_date)
    expect(filter.date_to).to eq(Date.current)
    expect(filter.interval).to eq('jour')
    expect(filter.routes).to eq([])
    expect(filter.routes_submitted?).to be(false)
  end

  it 'flags routes as submitted as soon as the key is present' do
    filter = described_class.new(provider, 'entreprise', routes: [''])

    expect(filter.routes).to eq([])
    expect(filter.routes_submitted?).to be(true)
  end

  it 'rejects blank routes' do
    filter = described_class.new(provider, 'entreprise', routes: ['', 'foo'])

    expect(filter.routes).to eq(['foo'])
  end

  it 'falls back to day interval when invalid' do
    filter = described_class.new(provider, 'entreprise', interval: 'wat')

    expect(filter.interval).to eq('jour')
  end

  it 'is invalid when date_to is before date_from' do
    filter = described_class.new(provider, 'entreprise', date_from: Date.current, date_to: Date.current - 2.days)

    expect(filter).not_to be_valid
    expect(filter.errors[:date_to]).to be_present
  end
end
