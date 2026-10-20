RSpec.describe Admin::KpiQuery do
  subject(:query) { described_class.new(filter) }

  let(:today) { Date.current }
  let(:filter) { Admin::StatisticsFilter.new(date_from: today - 6.days, date_to: today) }
  let(:insee) { 'api_entreprise/v3_and_more/insee/etablissements' }
  let(:token) { create(:token, authorization_request: create(:authorization_request, :with_demandeur, external_id: 'DP-1')) }

  def log(days_ago, status: '200', **attributes)
    create(:access_log, controller: insee, status:, token:, timestamp: (today - days_ago.days).in_time_zone.change(hour: 12), **attributes)
  end

  it 'compares the period without today to the previous period of the same length' do
    log(6)
    log(1)
    log(0)
    log(8)

    expect([query.total_calls, query.previous_total_calls]).to eq([2, 1])
  end

  it 'filters on the datapass' do
    log(5)
    create(:access_log, controller: insee, status: '200', timestamp: (today - 5.days).in_time_zone.change(hour: 12))

    expect(query.total_calls).to eq(2)

    filter.external_id = 'DP-1'
    expect(query.total_calls).to eq(1)
  end

  it 'splits calls into successes, not found and others' do
    log(5)
    log(5, status: '404')
    log(5, status: '502')

    expect(query.error_breakdown).to eq('Succès' => 1, 'Non trouvés' => 1, 'Autre' => 1)
  end

  it 'ranks the datapass whose calls varied the most, with their demandeur' do
    3.times { log(5) }
    log(8)

    expect(query.top_variations).to eq(
      [{ source_id: 'DP-1', domaine: 'entreprise', email: token.authorization_request.demandeur.email,
         current: 3, previous: 1, variation: 200.0, variation_brute: 2 }]
    )
  end
end
