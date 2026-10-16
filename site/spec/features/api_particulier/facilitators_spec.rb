require 'rails_helper'

RSpec.describe 'API Particulier: facilitators dashboard', app: :api_particulier do
  let(:password) { 'mot-de-passe-des-facilitateurs' }

  let!(:transport_authorization) do
    create(:authorization_request, :with_organization,
      api: 'particulier',
      demarche: 'api-particulier-tarification-transports',
      status: 'validated',
      siret: '21310555400017',
      external_id: '1001')
  end

  before do
    stub_credential(:api_particulier_facilitators_password, password)
  end

  def sign_in_as_facilitator(with_password: password)
    visit api_particulier_facilitators_path
    fill_in 'Mot de passe', with: with_password
    click_on 'Accéder aux demandes'
  end

  describe 'access' do
    it 'asks for the password and lists no request to a visitor without it' do
      visit api_particulier_facilitators_path

      expect(page.status_code).to eq(401)
      expect(page).to have_field('Mot de passe')
      expect(page).to have_no_text('COMMUNE DE TOULOUSE')
    end

    it 'refuses a wrong password and lists no request' do
      sign_in_as_facilitator(with_password: 'mauvais-mot-de-passe')

      expect(page.status_code).to eq(401)
      expect(page).to have_text('Mot de passe incorrect')
      expect(page).to have_no_text('COMMUNE DE TOULOUSE')
    end

    it 'refuses an empty password when none is configured' do
      stub_credential(:api_particulier_facilitators_password, '')

      sign_in_as_facilitator(with_password: '')

      expect(page).to have_text('Mot de passe incorrect')
      expect(page).to have_no_text('COMMUNE DE TOULOUSE')
    end

    it 'lists the requests to a facilitator with the right password' do
      sign_in_as_facilitator

      expect(page).to have_current_path(api_particulier_facilitators_path)
      expect(page).to have_css("##{dom_id(transport_authorization)}", text: 'COMMUNE DE TOULOUSE')
    end

    it 'gives a facilitator access to no other page of the site' do
      sign_in_as_facilitator
      expect(page).to have_text('COMMUNE DE TOULOUSE')

      [
        api_particulier_user_profile_path,
        api_particulier_authorization_requests_path,
        api_particulier_authorization_request_path(transport_authorization),
        api_particulier_dashboard_reporter_path,
        admin_users_path
      ].each do |path|
        visit path

        expect(page).to have_current_path(api_particulier_login_path), "#{path} is reachable by a facilitator"
      end
    end

    it 'locks the page again once the facilitator logs out' do
      sign_in_as_facilitator
      click_on 'Se déconnecter'

      expect(page).to have_field('Mot de passe')
      expect(page).to have_no_text('COMMUNE DE TOULOUSE')
    end

    it 'locks the page for facilitators who signed in with a password since changed' do
      sign_in_as_facilitator
      stub_credential(:api_particulier_facilitators_password, 'nouveau-mot-de-passe')

      visit api_particulier_facilitators_path

      expect(page).to have_field('Mot de passe')
      expect(page).to have_no_text('COMMUNE DE TOULOUSE')
    end

    it 'does not show the list again from the browser history once the password changed', :js do
      sign_in_as_facilitator
      expect(page).to have_text('COMMUNE DE TOULOUSE')

      click_on 'FAQ & Contact'
      expect(page).to have_no_text('COMMUNE DE TOULOUSE')
      stub_credential(:api_particulier_facilitators_password, 'nouveau-mot-de-passe')
      page.go_back

      expect(page).to have_field('Mot de passe')
      expect(page).to have_no_text('COMMUNE DE TOULOUSE')
    end

    it 'stops checking passwords after 10 attempts within 3 minutes' do
      10.times { sign_in_as_facilitator(with_password: 'mauvais-mot-de-passe') }

      sign_in_as_facilitator

      expect(page.status_code).to eq(429)
      expect(page).to have_text('Trop de tentatives')
      expect(page).to have_no_text('COMMUNE DE TOULOUSE')
    end
  end

  describe 'list' do
    let!(:eaje_request_in_progress) do
      create(:authorization_request, api: 'particulier', demarche: 'api-particulier-tarification-eaje', status: 'submitted', external_id: '1002')
    end
    let!(:revoked_ccas_authorization) do
      create(:authorization_request, api: 'particulier', demarche: 'api-particulier-ccas-paxtel', status: 'revoked', external_id: '1003')
    end
    let!(:refused_request) do
      create(:authorization_request, api: 'particulier', demarche: 'api-particulier-tarification-transports', status: 'refused', external_id: '1004')
    end
    let!(:archived_request) do
      create(:authorization_request, api: 'particulier', demarche: 'api-particulier-tarification-transports', status: 'archived', external_id: '1005')
    end
    let!(:request_outside_facilitated_use_cases) do
      create(:authorization_request, api: 'particulier', demarche: 'api-particulier', status: 'validated', external_id: '1006')
    end

    before { sign_in_as_facilitator }

    it 'shows the organization, status, SIRET and a link to the DataPass request' do
      within("##{dom_id(transport_authorization)}") do
        expect(page).to have_text('COMMUNE DE TOULOUSE')
        expect(page).to have_text('Validée')
        expect(page).to have_text('21310555400017')
        expect(page).to have_text('Tarification des transports')
        expect(page).to have_link('1001', href: %r{public/demandes/#{transport_authorization.public_id}})
      end
    end

    it 'lists the validated, revoked and in progress requests of the facilitated use cases only' do
      expect(page).to have_css("##{dom_id(transport_authorization)}")
      expect(page).to have_css("##{dom_id(eaje_request_in_progress)}", text: 'En cours')
      expect(page).to have_css("##{dom_id(revoked_ccas_authorization)}", text: 'Révoquée')
      expect(page).to have_no_css("##{dom_id(refused_request)}")
      expect(page).to have_no_css("##{dom_id(archived_request)}")
      expect(page).to have_no_css("##{dom_id(request_outside_facilitated_use_cases)}")
    end

    it 'filters on a use case' do
      select 'Tarification EAJE (crèches)', from: "Cas d'usage"
      click_on 'Filtrer'

      expect(page).to have_css("##{dom_id(eaje_request_in_progress)}")
      expect(page).to have_no_css("##{dom_id(transport_authorization)}")
      expect(page).to have_no_css("##{dom_id(revoked_ccas_authorization)}")
    end

    it 'filters on validated authorizations only' do
      select 'Validées', from: 'Statut'
      click_on 'Filtrer'

      expect(page).to have_css("##{dom_id(transport_authorization)}")
      expect(page).to have_no_css("##{dom_id(eaje_request_in_progress)}")
      expect(page).to have_no_css("##{dom_id(revoked_ccas_authorization)}")
    end

    it 'filters on validated authorizations and requests in progress' do
      select 'Validées et en cours', from: 'Statut'
      click_on 'Filtrer'

      expect(page).to have_css("##{dom_id(transport_authorization)}")
      expect(page).to have_css("##{dom_id(eaje_request_in_progress)}")
      expect(page).to have_no_css("##{dom_id(revoked_ccas_authorization)}")
    end
  end
end
