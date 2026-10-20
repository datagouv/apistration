RSpec.describe Admin::APIHealthQuery do
  subject(:query) { described_class.new(Admin::StatisticsFilter.new) }

  def log(controller, status, version: 'v3', timestamp: 5.minutes.ago)
    create(:access_log, controller:, status:, api_version: version, timestamp:)
  end

  it 'gives the share of each status per provider over the last hour, worst 502 rate first' do
    %w[200 200 404].each { |status| log('api_entreprise/v3_and_more/insee/etablissements', status) }
    log('api_entreprise/v3_and_more/insee/etablissements', '502', timestamp: 50.minutes.ago)
    %w[502 502 500 200].each { |status| log('api_particulier/v3_and_more/cnav/quotient_familial', status) }
    log('api_entreprise/v3_and_more/insee/etablissements', '502', timestamp: 2.hours.ago)

    expect(query.instant_status).to eq(
      [
        { provider: 'CNAV', bouquet: 'API_PARTICULIER', version: 'v3', total: 4,
          rate_502: 0.5, rate_200: 0.25, rate_404: 0.0, rate_others: 0.25 },
        { provider: 'INSEE', bouquet: 'API_ENTREPRISE', version: 'v3', total: 4,
          rate_502: 0.25, rate_200: 0.5, rate_404: 0.25, rate_others: 0.0 }
      ]
    )
  end

  it 'ignores client errors and API Entreprise v2' do
    %w[401 403 422].each { |status| log('api_entreprise/v3_and_more/insee/etablissements', status) }
    log('api_entreprise/v2/etablissements', '502', version: 'v2')

    expect(query.instant_status).to be_empty
  end
end
