# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'API Entreprise stats', app: :api_entreprise do
  let(:last_week) { Time.zone.local(2026, 10, 7, 12) }

  def log_call(controller, params: {}, status: '200', timestamp: last_week)
    create(:access_log, controller:, params:, status:, timestamp:)
  end

  before { Timecop.freeze(Time.zone.local(2026, 10, 14, 10)) }

  after { Timecop.return }

  it 'loads weekly and monthly stats lazily' do
    visit stats_path

    expect(page).to have_css('h1', text: 'Statistiques API Entreprise')
    expect(page).to have_css("turbo-frame#stats_week[src='#{stats_section_path(period: 'week')}']")
    expect(page).to have_css("turbo-frame#stats_month[src='#{stats_section_path(period: 'month')}']")
  end

  it 'counts helped companies by distinct SIREN' do
    2.times { log_call('api_entreprise/v3_and_more/insee/unites_legales', params: { siren: '123456789' }) }
    log_call('api_entreprise/v3_and_more/insee/unites_legales', params: { siren: '987654321' })

    visit stats_section_path(period: 'week')

    expect(page).to have_css('.fr-tile', text: /^\s*2\s+Entreprises aidées/)
  end

  it 'ignores rejected calls' do
    log_call('api_entreprise/v3_and_more/insee/unites_legales')
    log_call('api_entreprise/v3_and_more/insee/unites_legales', status: '401')

    visit stats_section_path(period: 'week')

    expect(page).to have_css('.fr-tile', text: /^\s*1\s+Appels/)
  end

  it 'compares with the previous week' do
    log_call('api_entreprise/v3_and_more/insee/unites_legales')
    2.times { log_call('api_entreprise/v3_and_more/insee/unites_legales', timestamp: last_week - 1.week) }

    visit stats_section_path(period: 'week')

    expect(page).to have_css('.fr-tile', text: /Appels\s+-50 %\s+par rapport à la semaine précédente \(2\)/)
  end
end
