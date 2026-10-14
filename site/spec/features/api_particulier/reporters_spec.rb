# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'API Particulier', app: :api_particulier do
  subject(:visit_dashboard) do
    visit api_particulier_dashboard_reporter_path
  end

  let!(:quotient_familial_request) { create(:authorization_request, :submitted, api: 'particulier', intitule: 'Cantine scolaire', scopes: %w[cnaf_quotient_familial]) }
  let!(:demandeur_emploi_request) { create(:authorization_request, :submitted, api: 'particulier', intitule: 'Aide au retour à l\'emploi', scopes: %w[pole_emploi_identite]) }
  let!(:never_submitted_request) { create(:authorization_request, api: 'particulier', intitule: 'Brouillon jamais soumis', scopes: %w[cnaf_quotient_familial]) }

  before do
    stub_credential(:api_particulier_reporters, {
      cnaf_: ['user@yopmail.com'],
      pole_emploi_: ['other@yopmail.com']
    })
    login_as(user)
  end

  context 'with a reporter' do
    let(:user) { create(:user, email: 'user@yopmail.com') }

    it 'lists only the submitted requests of the reporter scope groups' do
      visit_dashboard

      expect(page).to have_current_path(api_particulier_dashboard_reporter_path)
      expect(page).to have_text('Quotient Familial')
      expect(page).to have_no_text('France travail')

      expect(page).to have_css("##{dom_id(quotient_familial_request)}", text: 'Cantine scolaire')
      expect(page).to have_no_css("##{dom_id(demandeur_emploi_request)}")
    end

    it 'does not list requests whose scopes only contain the group name after their start' do
      other_request = create(:authorization_request, :submitted, api: 'particulier', scopes: %w[msa_cnaf_quotient_familial])

      visit_dashboard

      expect(page).to have_css("##{dom_id(quotient_familial_request)}")
      expect(page).to have_no_css("##{dom_id(other_request)}")
    end

    it 'does not list requests never submitted' do
      visit_dashboard

      expect(page).to have_no_css("##{dom_id(never_submitted_request)}")
    end
  end

  context 'with admin user' do
    let(:user) { create(:user, email: 'admin@beta.gouv.fr') }

    it 'lists the submitted requests of all scope groups' do
      visit_dashboard

      expect(page).to have_text('Quotient Familial')
      expect(page).to have_text('France travail')

      expect(page).to have_css("##{dom_id(quotient_familial_request)}")
      expect(page).to have_css("##{dom_id(demandeur_emploi_request)}")
      expect(page).to have_no_css("##{dom_id(never_submitted_request)}")
    end
  end

  context 'with invalid user' do
    let(:user) { create(:user, email: 'unknown@yopmail.com') }

    it 'redirects to root path' do
      visit_dashboard

      expect(page).to have_current_path(root_path)
    end
  end
end
