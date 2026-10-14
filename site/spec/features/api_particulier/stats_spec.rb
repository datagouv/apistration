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
    expect(page).to have_css('.fr-tile', text: /^\s*5\s+Pièces justificatives transmises/)
    expect(page).to have_css('.fr-tile', text: /^\s*2\s+Quotients familiaux transmis/)
    expect(page).to have_css('.fr-tile', text: /^\s*2\s+Cartes étudiantes transmises/)
    expect(page).to have_css('.fr-tile', text: /^\s*1\s+Complémentaire santé solidaire/)
  end
end
