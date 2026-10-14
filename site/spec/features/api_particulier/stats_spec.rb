# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'API Particulier stats', app: :api_particulier do
  let(:last_month) { Time.zone.local(2026, 9, 15, 12) }

  def log_call(controller)
    create(:access_log, controller:, status: '200', timestamp: last_month)
  end

  before { Timecop.freeze(Time.zone.local(2026, 10, 14, 10)) }

  after { Timecop.return }

  it 'counts transmitted documents per service across API versions' do
    log_call('api_particulier/v2/cnav/quotient_familial_v2')
    log_call('api_particulier/v3_and_more/cnav/quotient_familial_with_civility')
    log_call('api_particulier/v3_and_more/mesri/statut_etudiant_with_ine')
    log_call('api_particulier/v3_and_more/cnous/etudiant_boursier_with_civility')
    log_call('api_particulier/v3_and_more/cnav/complementaire_sante_solidaire_with_civility')
    log_call('api_particulier/v2/introspect')
    log_call('api_particulier/ping_providers')

    PublicStatsWarmupJob.perform_now
    visit api_particulier_stats_section_path(period: 'month')

    expect(page).to have_css('h2', text: 'Sur le dernier mois')
    expect(page).to have_css('.stats-indicator', text: /^\s*Pièces justificatives transmises\s+5\b/)
    expect(page).to have_css('.stats-indicator', text: /^\s*Quotients familiaux transmis\s+2\b/)
    expect(page).to have_css('.stats-indicator', text: /^\s*Cartes étudiantes transmises\s+2\b/)
    expect(page).to have_css('.stats-indicator', text: /^\s*Complémentaire santé solidaire\s+1\b/)
  end

  it 'serves each JSON indicator under its former Metabase column name' do
    log_call('api_particulier/v3_and_more/cnav/quotient_familial_with_civility')
    PublicStatsWarmupJob.perform_now

    visit api_particulier_stats_indicator_path(period: 'month', indicator: 'quotient_familial', format: :json)

    expect(JSON.parse(page.body)).to eq([
      { 'timestamp' => '2026-09-01T00:00:00+02:00', 'Nb appels' => 1 },
      { 'timestamp' => '2026-08-01T00:00:00+02:00', 'Nb appels' => 0 }
    ])
  end
end
