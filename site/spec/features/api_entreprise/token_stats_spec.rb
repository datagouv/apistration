require 'rails_helper'

RSpec.describe 'Stats page for a token', app: :api_entreprise do
  let(:user) { token.users.first }
  let(:token) { create(:token) }

  def log_call(status:, timestamp: 1.minute.ago, path: '/v3/insee/sirene/unites_legales/123456789', target: token)
    create(:access_log, token: target, status:, timestamp:, path:)
  end

  before do
    login_as(user)
  end

  it 'displays the token details (happy path)' do
    visit token_stats_path(token)

    expect(page).to have_text(token.intitule)
    expect(page).to have_text(token.id)
  end

  it 'loads only the visible period and the latest calls on opening, another period when its tab is opened', :js do
    log_call(status: '200', timestamp: 2.hours.ago)

    visit token_stats_path(token)

    expect(page).to have_css("turbo-frame#token_stats_last_10_minutes[src$='#{token_stats_period_path(token, period: 'last_10_minutes')}']")
    expect(page).to have_css("turbo-frame#token_stats_last_requests[src$='#{token_last_requests_path(token)}']")
    expect(page).to have_css('turbo-frame#token_stats_last_30_hours:not([src])', visible: :all)
    expect(page).to have_css('turbo-frame#token_stats_last_8_days:not([src])', visible: :all)

    click_on '30 dernières heures'

    within('#token_stats_last_30_hours') do
      expect(page).to have_css('pie-chart')
    end
    expect(page).to have_css('turbo-frame#token_stats_last_8_days:not([src])', visible: :all)
  end

  it 'breaks down the calls of the period by status category' do
    2.times { log_call(status: '200') }
    log_call(status: '206')
    log_call(status: '404')
    log_call(status: '503')
    log_call(status: '409')
    log_call(status: nil)
    log_call(status: '200', timestamp: 1.hour.ago)
    log_call(status: '200', target: create(:token))

    visit token_stats_period_path(token, period: 'last_10_minutes')

    chart = page.find('pie-chart')
    expect(JSON.parse(chart['name'])).to eq(['Succès (3)', 'Non trouvé (1)', 'Erreur du fournisseur de données (1)', 'Autre (2)'])
    expect(JSON.parse(chart['y'])).to eq([[3, 1, 1, 2]])
  end

  it 'tells when the token made no call on the period' do
    log_call(status: '200', timestamp: 2.days.ago)

    visit token_stats_period_path(token, period: 'last_30_hours')

    expect(page).to have_text('Aucun appel sur cette période.')
  end

  it 'lists the latest calls of the token, most recent first' do
    log_call(status: '200', timestamp: 2.hours.ago, path: '/v3/older')
    log_call(status: '404', timestamp: 1.hour.ago, path: '/v3/newer')
    log_call(status: '200', path: '/v3/other-token', target: create(:token))

    visit token_last_requests_path(token)

    rows = page.all('tbody tr').map { |row| row.all('td').map(&:text) }
    expect(rows.map(&:second)).to eq(['/v3/newer', '/v3/older'])
    expect(rows.map(&:last)).to eq(%w[404 200])
  end

  context 'with the contact metier of the token' do
    let(:user) { create(:user) }

    before do
      create(:user_authorization_request_role, :contact_metier, authorization_request: token.authorization_request, user:)
      log_call(status: '200')
    end

    it 'sees the breakdown by status and the latest calls' do
      visit token_stats_path(token)

      expect(page).to have_css('turbo-frame#token_stats_last_10_minutes')
      expect(page).to have_css('turbo-frame#token_stats_last_requests')

      visit token_stats_period_path(token, period: 'last_10_minutes')

      expect(page).to have_css('pie-chart')

      visit token_last_requests_path(token)

      expect(page).to have_text('/v3/insee/sirene/unites_legales/123456789')
    end
  end

  context 'with another user' do
    let(:user) { create(:user) }

    it 'redirects to account homepage' do
      visit token_stats_path(token)

      expect(page).to have_current_path(authorization_requests_path, ignore_query: true)
    end

    it 'does not expose the token calls' do
      log_call(status: '200')

      visit token_last_requests_path(token)

      expect(page).to have_current_path(authorization_requests_path, ignore_query: true)
    end
  end
end
