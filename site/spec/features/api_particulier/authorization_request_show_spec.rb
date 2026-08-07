RSpec.describe 'displays show of authorization request', app: :api_particulier do
  subject(:go_to_authorization_request) do
    visit api_particulier_authorization_request_path(id: authorization_request.id)
  end

  let!(:authenticated_user) { create(:user, :demandeur, :contact_technique, :contact_metier) }
  let!(:non_authenticated_user) { create(:user, :demandeur) }
  let!(:authorization_request) do
    create(
      :authorization_request,
      demandeur_authorization_request_role: non_authenticated_user.user_authorization_request_roles.first,
      api: 'entreprise'
    )
  end

  let!(:token) do
    create(:token, authorization_request:, exp: 1.day.from_now.to_i)
  end

  describe 'when user is not authenticated' do
    it 'redirects to the login' do
      go_to_authorization_request
      expect(page).to have_current_path(api_particulier_login_path, ignore_query: true)
    end
  end

  describe 'when user is authenticated' do
    before do
      login_as(authenticated_user)
      go_to_authorization_request
    end

    describe 'when authorization_request does not belong to current_user' do
      it 'redirects to the index' do
        expect(page).to have_current_path(api_particulier_authorization_requests_path, ignore_query: true)
      end
    end

    describe 'when authorization_request belongs to current_user' do
      describe 'when it is not viewable by users' do
        let!(:authorization_request) do
          create(
            :authorization_request,
            :with_demandeur,
            demandeur: authenticated_user,
            api: 'entreprise',
            status: 'draft'
          )
        end

        it 'redirects to the index' do
          expect(page).to have_current_path(api_particulier_authorization_requests_path, ignore_query: true)
        end
      end

      describe 'when authorization_request is from api_particulier' do
        let!(:authorization_request) do
          create(
            :authorization_request,
            :with_demandeur,
            demandeur: authenticated_user,
            api: 'particulier',
            status: 'validated'
          )
        end

        it 'displays basic information' do
          expect(page).to have_current_path(api_particulier_authorization_request_path(id: authorization_request.id), ignore_query: true)
          expect(page).to have_text('Demande active')
          expect(page).to have_text(friendly_format_from_timestamp(authorization_request.created_at))
        end

        it 'displays a link to DataPass' do
          expect(page).to have_link(href: datapass_authorization_request_url(authorization_request))
        end

        describe 'tokens table' do
          let!(:other_token) { create(:token, authorization_request:, exp: 2.days.from_now.to_i, intitule: authorization_request.intitule) }

          it 'displays all tokens' do
            visit api_particulier_authorization_request_path(id: authorization_request.id)

            expect(page).to have_css('#' << dom_id(token))
            expect(page).to have_css('#' << dom_id(other_token))
          end
        end

        describe 'contacts section' do
          it 'displays the demandeur' do
            expect(page).to have_text(authorization_request.demandeur.full_name)
            expect(page).to have_text(authorization_request.demandeur.email)
          end

          describe 'when the user is the demandeur' do
            it 'shows the "its me" indicator' do
              expect(page).to have_text('c\'est moi')
            end
          end

          describe 'when the user is contact technique' do
            let!(:authorization_request) do
              create(
                :authorization_request,
                :with_demandeur,
                :with_contact_technique,
                demandeur: non_authenticated_user,
                contact_technique: authenticated_user,
                api: 'particulier',
                status: 'validated'
              )
            end

            it 'displays contact technique info' do
              expect(page).to have_text(authenticated_user.full_name)
            end
          end
        end
      end
    end
  end
end
