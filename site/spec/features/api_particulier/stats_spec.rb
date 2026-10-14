# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'API Particulier stats', app: :api_particulier do
  let(:last_month) { Time.zone.local(2026, 9, 15, 12) }

  def log_call(controller)
    create(:access_log, controller:, status: '200', timestamp: last_month)
  end

  before { Timecop.freeze(Time.zone.local(2026, 10, 14, 10)) }

  after { Timecop.return }

  it 'counts transmitted documents per service' do
    log_call('api_particulier/v2/cnaf/quotient_familial_v2')
    log_call('api_particulier/v2/dgfip/svair')
    log_call('api_particulier/v2/mesri/student_status')
    log_call('api_particulier/v2/cnous/student_scholarship')

    PublicStatsWarmupJob.perform_now
    visit api_particulier_stats_section_path(period: 'month')

    expect(page).to have_css('h2', text: 'Sur les 30 derniers jours')
    expect(page).to have_css('.fr-tile', text: /^\s*4\s+Pièces justificatives transmises/)
    expect(page).to have_css('.fr-tile', text: /^\s*1\s+Quotients familiaux transmis/)
    expect(page).to have_css('.fr-tile', text: /^\s*1\s+Avis d'impositions transmis/)
    expect(page).to have_css('.fr-tile', text: /^\s*2\s+Cartes étudiantes transmises/)
  end
end
