RSpec.describe 'Editor delegation request journey', app: :api_entreprise do
  let(:editor) { create(:editor, name: 'Omnikles ') }
  let(:editor_use_case) { create(:editor_use_case, editor:) }
  let(:editor_delegation_request) do
    create(:editor_delegation_request, :with_authorization_request, editor_use_case:, siret: '21340172201787', contact_email: 'achats@saint-exemple.fr')
  end
  let(:user) { create(:user, :with_full_name, email: 'agent@saint-exemple.fr') }

  before { stub_datapass_formulaires }

  def fill_in_data_protection_officer
    fill_in 'Prénom', with: 'Dominique'
    fill_in 'Nom', with: 'Leroy'
    fill_in 'Adresse électronique', with: 'dpo@saint-exemple.fr'
    fill_in 'Téléphone', with: '01 23 45 67 89'
    fill_in 'Fonction', with: 'Délégué à la protection des données'
  end

  it 'answers 404 to an invalid link' do
    expect { visit '/editeurs/omnikles/habilitation/forged' }.to raise_error(ActionController::RoutingError)
  end

  it 'answers 404 to a link under another editor name' do
    token = editor_delegation_request.generate_token_for(:invitation)

    expect { visit "/editeurs/other/habilitation/#{token}" }.to raise_error(ActionController::RoutingError)
  end

  describe 'identification' do
    before do
      stub_request(:get, 'https://fca.integ01.dev-agentconnect.fr/api/v2/.well-known/openid-configuration')

      OmniAuth.config.test_mode = true
      OmniAuth.config.mock_auth[:proconnect_api_entreprise] = OmniAuth::AuthHash.new(
        info: { email: user.email, first_name: user.first_name, last_name: user.last_name, uid: user.oauth_api_gouv_id },
        extra: { raw_info: { siret: proconnect_siret } }
      )
    end

    after { OmniAuth.config.test_mode = false }

    context 'when the agent acts for the targeted organization' do
      let(:proconnect_siret) { '21340172201787' }

      it 'presents the request, then brings the agent back to it after ProConnect' do
        visit editor_delegation_request.invitation_path

        expect(page).to have_text('Omnikles')
        expect(page).to have_text('21340172201787')

        click_on 'login_pro_connect'

        expect(page).to have_current_path(%r{/delegue-protection-donnees\z})
      end
    end

    context 'when the agent acts for another establishment of the same organization' do
      let(:proconnect_siret) { '21340172200011' }

      it 'accepts the agent' do
        visit editor_delegation_request.invitation_path
        click_on 'login_pro_connect'

        expect(page).to have_current_path(%r{/delegue-protection-donnees\z})
      end
    end

    context 'when the agent acts for another organization' do
      let(:proconnect_siret) { '13002526500013' }

      it 'refuses the agent and reminds the expected organization' do
        visit editor_delegation_request.invitation_path
        click_on 'login_pro_connect'

        expect(page).to have_text('21340172201787')
        expect(page).to have_text('13002526500013')
        expect(page).to have_no_field('Prénom')
      end
    end
  end

  context 'when an agent of another organization opens a step directly' do
    before { login_as(user, siret: '13002526500013') }

    it 'sends the agent back to the link' do
      visit "#{editor_delegation_request.invitation_path}/verification"

      expect(page).to have_current_path(editor_delegation_request.invitation_path)
    end
  end

  context 'when the agent is identified for the organization' do
    before do
      create(:editor_delegation_request, editor_use_case:, siret: '21030190500018', contact_email: 'achats@saint-exemple.fr')
      create(:editor_delegation_request, :submitted, editor_use_case:, siret: '21030190500026', contact_email: 'achats@saint-exemple.fr')
      create(:editor_delegation_request, editor_use_case:, siret: '21030190500034', contact_email: 'other@exemple.fr')

      login_as(user, siret: '21340172201787')
    end

    it 'saves the data protection officer for later' do
      visit editor_delegation_request.invitation_path

      fill_in 'Prénom', with: 'Dominique'
      click_on 'Sauvegarder'

      expect(editor_delegation_request.reload.delegue_protection_donnees_given_name).to eq('Dominique')

      visit editor_delegation_request.invitation_path

      expect(page).to have_field('Prénom', with: 'Dominique')
    end

    it 'requires the five fields of the data protection officer' do
      visit editor_delegation_request.invitation_path

      fill_in 'Prénom', with: 'Dominique'
      click_on 'Vérifier ma demande'

      expect(page).to have_css('.fr-error-text')
      expect(page).to have_no_text('Vérifiez votre demande')
    end

    it 'submits the request once the summary is checked, then lists the other requests of the contact' do
      visit editor_delegation_request.invitation_path

      fill_in_data_protection_officer
      click_on 'Vérifier ma demande'

      expect(page).to have_text('Vérifiez votre demande')
      expect(page).to have_text('Dématérialisation des marchés publics')
      expect(page).to have_text('Marchés publics')
      expect(page).to have_text('dpo@saint-exemple.fr')
      expect(page).to have_text('Jean-Marie')

      click_on 'Soumettre la demande'

      expect(page).to have_css('.fr-error-text')
      expect(editor_delegation_request.reload).not_to be_submitted

      check 'terms_of_service_accepted'
      check 'data_protection_officer_informed'
      click_on 'Soumettre la demande'

      expect(page).to have_text('Votre demande d’habilitation est soumise')
      expect(editor_delegation_request.reload).to be_submitted
      expect(editor_delegation_request.submitted_by_user).to eq(user)

      expect(page).to have_link(href: EditorDelegationRequest.find_by(siret: '21030190500018').invitation_path)
      expect(page).to have_no_text('21030190500026')
      expect(page).to have_no_text('21030190500034')
    end

    context 'when DataPass is unavailable' do
      before do
        editor_delegation_request.update!(data: attributes_for(:editor_delegation_request, :with_dpo)[:data])
        allow(DatapassAPIClient).to receive(:new).and_return(instance_double(DatapassAPIClient).tap do |client|
          allow(client).to receive(:list_formulaires).and_raise(DatapassAPIClient::Error)
        end)
      end

      it 'asks the agent to come back later' do
        visit "#{editor_delegation_request.invitation_path}/verification"

        expect(page).to have_text('momentanément indisponible')
      end
    end
  end

  context 'when the request is already submitted' do
    let(:editor_delegation_request) { create(:editor_delegation_request, :submitted, :with_authorization_request, editor_use_case:) }

    it 'shows the confirmation, without any new submission' do
      visit editor_delegation_request.invitation_path

      expect(page).to have_text('Votre demande d’habilitation est soumise')
      expect(page).to have_no_button('login_pro_connect')
    end
  end
end
