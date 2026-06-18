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

        expect(page).to have_text("Vous n'avez aucune demande")
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

        expect(page).to have_text('Demandes API Particulier (2)')

        expect(page).to have_css('#' << dom_id(authorization_request_active))
        expect(page).to have_css('#' << dom_id(authorization_request_archived))

        expect(page).to have_text('Mon habilitation active')
        expect(page).to have_text('Mon habilitation archivée')

        expect(page).to have_text('Demande active')
        expect(page).to have_text('Demande archivée')
      end

      it 'displays the user role on each card' do
        go_to_authorization_requests_index

        expect(page).to have_text('demandeur')
      end

      it 'links to the authorization request detail page' do
        go_to_authorization_requests_index

        expect(page).to have_link('Mon habilitation active', href: api_particulier_authorization_request_path(authorization_request_active))
      end
    end
  end
end
