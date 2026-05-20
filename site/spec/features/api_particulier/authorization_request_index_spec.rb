RSpec.describe 'displays authorization requests', app: :api_particulier do
  subject(:go_to_authorization_requests_index) do
    visit api_particulier_authorization_requests_path
  end

  let!(:authenticated_user) { create(:user) }

  describe 'when user is not authenticated' do
    it 'redirects to the login' do
      go_to_authorization_requests_index
      expect(page).to have_current_path(api_particulier_login_path, ignore_query: true)
    end
  end

  describe 'when user is authenticated' do
    before do
      login_as(authenticated_user)
    end

    describe 'when the user does not have authorization requests' do
      it 'displays the empty state' do
        go_to_authorization_requests_index

        expect(page).to have_text("Vous n'avez aucune habilitation")
      end
    end

    describe 'when the user has authorization requests' do
      let!(:authorization_request_active) do
        create(
          :authorization_request,
          :with_demandeur,
          :validated,
          intitule: 'Mon habilitation active',
          demandeur: authenticated_user,
          api: 'particulier'
        )
      end

      let!(:authorization_request_archived) do
        create(
          :authorization_request,
          :with_demandeur,
          :submitted,
          status: 'archived',
          intitule: 'Mon habilitation archivée',
          demandeur: authenticated_user,
          api: 'particulier'
        )
      end

      it 'displays all authorization requests as cards' do
        go_to_authorization_requests_index

        expect(page).to have_text('Habilitations API Particulier (2)')

        expect(page).to have_css('#' << dom_id(authorization_request_active))
        expect(page).to have_css('#' << dom_id(authorization_request_archived))

        expect(page).to have_text('Mon habilitation active')
        expect(page).to have_text('Mon habilitation archivée')

        expect(page).to have_text('Habilitation active')
        expect(page).to have_text('Habilitation archivée')
      end

      it 'displays the organization of each authorization request' do
        authorization_request_archived.update!(siret: '21750001600019')
        create(:organization, :with_insee_payload, siret: authorization_request_active.siret)
        create(:organization, :with_insee_payload, siret: authorization_request_archived.siret)

        go_to_authorization_requests_index

        {
          authorization_request_active => 'DIRECTION INTERMINISTERIELLE DU NUMERIQUE (13002526500013)',
          authorization_request_archived => 'VILLE DE PARIS (21750001600019)'
        }.each do |authorization_request, organization_label|
          within("##{dom_id(authorization_request)} .authorization_request-siret") do
            expect(page).to have_link(
              organization_label,
              href: "https://annuaire-entreprises.data.gouv.fr/etablissement/#{authorization_request.siret}"
            )
            expect(page).to have_css('a[target="_blank"][rel="noopener noreferrer"]')
          end
        end
      end

      it 'displays the user role on each card' do
        go_to_authorization_requests_index

        within("##{dom_id(authorization_request_active)}") do
          expect(page).to have_text('Demandeur')
        end
      end

      it 'links each card to its DataPass demande in a new tab' do
        go_to_authorization_requests_index

        within("##{dom_id(authorization_request_active)}") do
          expect(page).to have_link(href: datapass_authorization_request_url(authorization_request_active))
        end
        expect(page).not_to expose_window_opener
      end

      it 'links to the authorization request detail page' do
        go_to_authorization_requests_index

        expect(page).to have_link('Mon habilitation active', href: api_particulier_authorization_request_path(authorization_request_active))
      end
    end
  end
end
