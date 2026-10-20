RSpec.describe Admin::AnnualStatQuery do
  subject(:query) { described_class.new(filter) }

  let(:this_month) { Date.current.beginning_of_month }
  let(:filter) { Admin::StatisticsFilter.new(date_from: this_month - 2.months + 14.days, domaine: 'entreprise') }
  let(:insee) { 'api_entreprise/v3_and_more/insee/etablissements' }
  let(:token) { create(:token) }

  def log(status, day: this_month - 1.month + 2.days, **attributes)
    create(:access_log, controller: insee, status:, token:, timestamp: day.in_time_zone.change(hour: 12), **attributes)
  end

  it 'counts every call from the first day of the chosen month to the end of last month, whatever its status' do
    log('200', day: this_month - 2.months)
    log('401')
    log('502', day: this_month - 1.day)
    log('200', day: this_month)
    log('200', day: this_month - 3.months)

    expect(query.total_calls).to eq(3)
  end

  it 'counts as users the habilitations with at least one successful call' do
    log('200')
    create(:access_log, controller: insee, status: '404', timestamp: (this_month - 1.month).in_time_zone.change(hour: 12))

    expect(query.total_users).to eq(1)
  end

  it 'only counts successful calls in the monthly charts' do
    log('200', day: this_month - 2.months)
    log('200')
    log('404')

    expect(query.calls_by_month.map { |row| [row[:bucket].to_date, row[:value]] }).to eq([[this_month - 2.months, 1], [this_month - 1.month, 1]])
    expect(query.cumulative_calls_by_month.pluck(:value)).to eq([1, 2])
  end

  it 'splits the success rate into successes, not found, provider errors and others until yesterday' do
    %w[200 404 502 500 422].each { |status| log(status, api_version: 'v3') }
    log('200', day: Date.current)

    expect(query.success_rate_breakdown).to eq('Succès' => 1, 'Non trouvé' => 1, 'Erreur fournisseur' => 1, 'Autre' => 2)
  end

  it 'only counts the chosen domain' do
    log('200')
    create(:access_log, controller: 'api_particulier/v3_and_more/cnav/quotient_familial', status: '200', timestamp: (this_month - 1.month).in_time_zone.change(hour: 12))

    expect(query.total_calls).to eq(1)
  end
end
