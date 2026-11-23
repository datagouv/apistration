RSpec.describe 'Editor delegation request journey', app: :api_entreprise do
  let(:editor) { create(:editor, name: 'Omnikles ') }
  let(:editor_use_case) { create(:editor_use_case, editor:) }
  let(:editor_delegation_request) do
    create(:editor_delegation_request, :with_authorization_request, editor_use_case:, siret: '21340172201787', contact_email: 'achats@saint-exemple.fr')
  end
  let(:user) { create(:user, :with_full_name, email: 'achats@saint-exemple.fr') }

  before { stub_datapass_formulaires }

  def fill_in_data_protection_officer(email: 'dpo@saint-exemple.fr')
    fill_in 'Prénom', with: 'Dominique'
    fill_in 'Nom', with: 'Leroy'
    fill_in 'Adresse électronique', with: email
    fill_in 'Téléphone', with: '01 23 45 67 89'
    fill_in 'Fonction', with: 'Délégué à la protection des données'
  end

  def consent
    check 'terms_of_service_accepted'
    check 'data_protection_officer_informed'
  end

  def create_request(siret, *traits, contact_email: 'achats@saint-exemple.fr')
    create(:editor_delegation_request, :with_authorization_request, *traits, editor_use_case:, siret:, contact_email:)
  end

  it 'answers 404 to an invalid link' do
    expect { visit '/editeurs/omnikles/habilitation/forged' }.to raise_error(ActionController::RoutingError)
  end

  it 'answers 404 to a link under another editor name' do
    token = editor_delegation_request.generate_token_for(:invitation)

    expect { visit "/editeurs/other/habilitation/#{token}" }.to raise_error(ActionController::RoutingError)
  end

  describe 'identification' do
    let(:proconnect_user) { user }

    before do
      create_request('21340172200011')
      stub_request(:get, 'https://fca.integ01.dev-agentconnect.fr/api/v2/.well-known/openid-configuration')

      OmniAuth.config.test_mode = true
      OmniAuth.config.mock_auth[:proconnect_api_entreprise] = OmniAuth::AuthHash.new(
        info: { email: proconnect_user.email, first_name: proconnect_user.first_name, last_name: proconnect_user.last_name, uid: proconnect_user.oauth_api_gouv_id },
        extra: { acr: 'eidas1-mfa', raw_info: { siret: '13002526500013' } }
      )
    end

    after { OmniAuth.config.test_mode = false }

    it 'presents the batch without its establishments, then brings the signatory back to it after ProConnect, whatever the SIRET chosen' do
      visit editor_delegation_request.invitation_path

      expect(page).to have_text('2 demandes d\'habilitation à signer')
      expect(page).to have_text('Omnikles')
      expect(page).to have_text('a***@saint-exemple.fr')
      expect(page).to have_no_text('21340172201787')

      click_on 'login_pro_connect'

      expect(page).to have_text('Signer vos 2 demandes')
      expect(page).to have_text('21340172201787')
    end

    context 'when the ProConnect account is not the one of the batch' do
      let(:proconnect_user) { create(:user, :with_full_name, email: 'autre.personne@saint-exemple.fr') }

      it 'refuses the account without showing anything of the requests' do
        visit editor_delegation_request.invitation_path
        click_on 'login_pro_connect'

        expect(page).to have_text('Ce compte ne correspond pas')
        expect(page).to have_text('autre.personne@saint-exemple.fr')
        expect(page).to have_no_text('21340172201787')
        expect(page).to have_no_text('21340172200011')
        expect(page).to have_no_button('Signer les 2 demandes')
      end
    end
  end

  context 'when a stranger opens a step directly' do
    before { login_as(create(:user, email: 'autre.personne@saint-exemple.fr')) }

    it 'sends the stranger back to the link' do
      visit "#{editor_delegation_request.invitation_path}/organisations"

      expect(page).to have_current_path(editor_delegation_request.invitation_path)
    end
  end

  context 'when the batch holds a single request' do
    before { login_as(user) }

    it 'completes the data protection officer and signs on a single page' do
      visit editor_delegation_request.invitation_path

      expect(page).to have_text('Signez la demande')
      expect(page).to have_text('Dématérialisation des marchés publics')
      expect(page).to have_no_text('Exclure des établissements')

      fill_in 'Prénom', with: 'Dominique'
      click_on 'Signer la demande'

      expect(page).to have_css('.fr-error-text')
      expect(page).to have_field('Prénom', with: 'Dominique')
      expect(editor_delegation_request.reload).not_to be_submitted

      fill_in_data_protection_officer
      consent
      click_on 'Signer la demande'

      expect(page).to have_text('Votre demande d’habilitation est signée')
      expect(editor_delegation_request.reload).to be_submitted
      expect(editor_delegation_request.submitted_by_user).to eq(user)
      expect(editor_delegation_request.delegue_protection_donnees_email).to eq('dpo@saint-exemple.fr')
    end
  end

  context 'when the batch spans several organizations' do
    let!(:same_organization) { create_request('21340172200011') }
    let!(:other_organization) { create_request('21030190500018') }
    let!(:already_submitted) { create_request('21030190500026', :submitted) }
    let!(:of_another_contact) { create_request('21030190500034', contact_email: 'other@exemple.fr') }

    before do
      editor_delegation_request
      login_as(user)
    end

    it 'signs every request at once, with a data protection officer common to the organizations' do
      visit editor_delegation_request.invitation_path

      expect(page).to have_text('Signer vos 3 demandes')
      expect(page).to have_no_text('21030190500026')
      expect(page).to have_no_text('21030190500034')

      fill_in_data_protection_officer
      consent
      click_on 'Signer les 3 demandes'

      expect(page).to have_text('Vos demandes d’habilitation sont signées')
      expect([editor_delegation_request, same_organization, other_organization].map(&:reload)).to all(be_submitted)
      expect([editor_delegation_request, same_organization, other_organization].map(&:delegue_protection_donnees_email)).to all(eq('dpo@saint-exemple.fr'))
      expect(already_submitted.reload.submitted_by_user).not_to eq(user)
      expect(of_another_contact.reload).not_to be_submitted
    end

    it 'leaves the excluded establishments pending' do
      visit editor_delegation_request.invitation_path

      fill_in_data_protection_officer
      uncheck 'Signer pour le SIRET 21340172200011'
      consent
      click_on 'Signer les 3 demandes'

      expect(page).to have_text('Vos demandes d’habilitation sont signées')
      expect(page).to have_text('1 établissement(s) restent en attente de signature')
      expect(editor_delegation_request.reload).to be_submitted
      expect(other_organization.reload).to be_submitted
      expect(same_organization.reload).not_to be_submitted

      click_on 'Les signer maintenant'

      expect(page).to have_text('Signez la demande')
      expect(page).to have_field('Adresse électronique', with: 'dpo@saint-exemple.fr')
    end

    context 'when the editor provided the data protection officer of some organizations only' do
      let!(:other_organization) { create_request('21030190500018', :with_dpo) }

      it 'refuses to sign until every organization has its data protection officer' do
        visit editor_delegation_request.invitation_path

        expect(page).to have_text('Délégué à la protection des données à renseigner')

        consent
        click_on 'Signer les 3 demandes'

        expect(page).to have_text('Renseignez le délégué à la protection des données')
        expect(editor_delegation_request.reload).not_to be_submitted

        click_on 'SIREN 213401722'
        fill_in_data_protection_officer(email: 'dpo@commune.fr')
        click_on 'Enregistrer'
        click_on 'Revenir à la signature'

        consent
        click_on 'Signer les 3 demandes'

        expect(page).to have_text('Vos demandes d’habilitation sont signées')
        expect(same_organization.reload.delegue_protection_donnees_email).to eq('dpo@commune.fr')
        expect(other_organization.reload.delegue_protection_donnees_email).to eq('dpo@saint-exemple.fr')
      end
    end

    context 'when the editor provided a data protection officer common to every organization' do
      let(:editor_delegation_request) { create_request('21340172201787', :with_dpo) }
      let!(:same_organization) { create_request('21340172200011', :with_dpo) }
      let!(:other_organization) { create_request('21030190500018', :with_dpo) }

      it 'changes it for a single organization only' do
        visit editor_delegation_request.invitation_path

        expect(page).to have_text('dpo@saint-exemple.fr, pour vos 2 organisations')

        click_on 'Modifier pour une ou plusieurs organisations'
        click_on 'Délégué de SIREN 210301905'
        fill_in 'Adresse électronique', with: 'dpo@autre-commune.fr'
        click_on 'Enregistrer'

        expect(other_organization.reload.delegue_protection_donnees_email).to eq('dpo@autre-commune.fr')
        expect(editor_delegation_request.reload.delegue_protection_donnees_email).to eq('dpo@saint-exemple.fr')
        expect(same_organization.reload.delegue_protection_donnees_email).to eq('dpo@saint-exemple.fr')
      end
    end

    context 'when DataPass is unavailable' do
      before do
        allow(MockedDatapassAPIClient).to receive(:new).and_return(instance_double(MockedDatapassAPIClient).tap do |client|
          allow(client).to receive(:list_formulaires).and_raise(DatapassAPIClient::Error)
        end)
      end

      it 'asks the signatory to come back later' do
        visit editor_delegation_request.invitation_path

        expect(page).to have_text('momentanément indisponible')
      end
    end
  end

  context 'when every request of the batch is already submitted' do
    let(:editor_delegation_request) { create_request('21340172201787', :submitted) }

    it 'asks to identify before showing anything' do
      visit editor_delegation_request.invitation_path

      expect(page).to have_button('login_pro_connect')
      expect(page).to have_no_text('21340172201787')
    end

    it 'shows the confirmation to the signatory, without any new submission' do
      login_as(user)
      visit editor_delegation_request.invitation_path

      expect(page).to have_text('Votre demande d’habilitation est signée')
      expect(page).to have_no_button('Signer la demande')
    end
  end

  context 'when the editor gave no contact email' do
    let(:editor_delegation_request) { create_request('21340172201787', contact_email: nil) }

    it 'offers no identification, since nobody could sign' do
      visit editor_delegation_request.invitation_path

      expect(page).to have_text('ne nous a pas transmis l\'adresse électronique du signataire')
      expect(page).to have_no_button('login_pro_connect')
    end
  end

  describe 'DataPass webhooks simulation' do
    include ActiveJob::TestHelper

    let(:editor_delegation_request) { create(:editor_delegation_request, :submitted, :with_authorization_request, editor_use_case:, contact_email: user.email, submitted_by_user: user) }
    let(:authorization_request) { editor_delegation_request.authorization_request }
    let!(:delegation) { create(:editor_delegation, editor:, authorization_request:, created_via: 'editor_delegation_request') }

    before do
      login_as(user)
      allow(UpdateOrganizationINSEEPayloadJob).to receive(:perform_later)
      allow(Rails.application).to receive(:config_for).and_call_original
      allow(Rails.application).to receive(:config_for).with('datapass_webhooks_entreprise').and_return(
        Rails.application.config_for('datapass_webhooks_entreprise', env: 'production')
      )
    end

    after { clear_enqueued_jobs }

    it 'runs the real webhooks on the request, outside of production' do
      visit editor_delegation_request.invitation_path

      click_on 'Simuler submit'

      expect(authorization_request.reload.external_id).to be_present
      expect(authorization_request.status).to eq('submitted')

      click_on 'Simuler approve'

      expect(authorization_request.reload.validated_at).to be_present
      expect(delegation.reload.revoked_at).to be_nil
      expect(AuthorizationRequest.count).to eq(1)
    end

    it 'cuts the access through the editor on refusal' do
      visit editor_delegation_request.invitation_path

      click_on 'Simuler submit'
      click_on 'Simuler refuse'

      expect(authorization_request.reload).to be_archived
      expect(delegation.reload.revoked_at).to be_present
    end

    context 'when in production' do
      before { allow(Rails).to receive(:env).and_return(ActiveSupport::StringInquirer.new('production')) }

      it 'offers no simulation' do
        visit editor_delegation_request.invitation_path

        expect(page).to have_text('Votre demande d’habilitation est signée')
        expect(page).to have_no_button('Simuler submit')
      end
    end
  end
end
