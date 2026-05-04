RSpec.describe Provider::DashboardFilter do
  let(:provider) { instance_double(APIEntreprise::Provider, routes_or_uid_to_match: ['insee']) }

  it 'defaults date range to last 7 days' do
    filter = described_class.new(provider)

    expect(filter.date_from).to eq(7.days.ago.to_date)
    expect(filter.date_to).to eq(Date.current)
    expect(filter.interval).to eq('jour')
    expect(filter.routes).to eq([])
  end

  it 'rejects blank routes' do
    filter = described_class.new(provider, routes: ['', 'foo'])

    expect(filter.routes).to eq(['foo'])
  end

  it 'falls back to day interval when invalid' do
    filter = described_class.new(provider, interval: 'wat')

    expect(filter.interval).to eq('jour')
  end

  it 'is invalid when date_to is before date_from' do
    filter = described_class.new(provider, date_from: Date.current, date_to: Date.current - 2.days)

    expect(filter).not_to be_valid
    expect(filter.errors[:date_to]).to be_present
  end
end
