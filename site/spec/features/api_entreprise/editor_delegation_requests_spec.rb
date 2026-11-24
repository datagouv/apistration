RSpec.describe 'Editor delegation request journey', app: :api_entreprise do
  include ActiveJob::TestHelper

  let(:editor) { create(:editor, name: 'Omnikles ') }
  let(:editor_delegation_campaign) { create(:editor_delegation_campaign, editor:) }
  let(:editor_delegation_request) do
    create(:editor_delegation_request, :with_authorization_request, editor_delegation_campaign:, siret: '21340172201787', contact_email: 'achats@saint-exemple.fr')
  end
  let(:user) { create(:user, :with_full_name, email: 'achats@saint-exemple.fr') }

  let!(:datapass) { stub_datapass_formulaires }

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
    create(:editor_delegation_request, :with_authorization_request, *traits, editor_delegation_campaign:, siret:, contact_email:)
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

      expect(page).to have_text('2 demandes d\'habilitation à soumettre')
      expect(page).to have_text('Omnikles')
      expect(page).to have_text('a***@saint-exemple.fr')
      expect(page).to have_no_text('21340172201787')

      click_on 'login_pro_connect'

      expect(page).to have_text('Soumettre vos 2 demandes')
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
        expect(page).to have_no_button('Soumettre les 2 demandes')
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

    it 'completes the data protection officer, then shows what is signed before signing' do
      visit editor_delegation_request.invitation_path

      expect(page).to have_css('.fr-stepper__title', text: 'Votre délégué à la protection des données')
      expect(page).to have_no_text('Exclure des établissements')

      fill_in 'Prénom', with: 'Dominique'
      click_on 'Continuer'

      expect(page).to have_css('.fr-error-text')
      expect(page).to have_field('Prénom', with: 'Dominique')

      fill_in_data_protection_officer
      click_on 'Continuer'

      expect(page).to have_css('.fr-stepper__title', text: 'Vérifier et soumettre')
      expect(page).to have_text('Ce que vous soumettez')
      expect(page).to have_text('Dématérialisation des marchés publics')
      expect(page).to have_text('dpo@saint-exemple.fr')

      click_on 'Soumettre la demande'

      expect(page).to have_css('.fr-error-text')
      expect(editor_delegation_request.reload).not_to be_submitted

      consent
      click_on 'Soumettre la demande'

      expect(page).to have_text('Votre demande d’habilitation est soumise')
      expect(editor_delegation_request.reload).to be_submitted
      expect(editor_delegation_request.submitted_by_user).to eq(user)
      expect(editor_delegation_request.delegue_protection_donnees_email).to eq('dpo@saint-exemple.fr')
    end

    it 'creates the request in DataPass for the signatory in the background, then submits it with the consents given' do
      visit editor_delegation_request.invitation_path
      fill_in_data_protection_officer
      click_on 'Continuer'
      consent
      perform_enqueued_jobs { click_on 'Soumettre la demande' }

      expect(datapass).to have_received(:create_demande).with(
        hash_including(
          form_uid: editor_delegation_campaign.datapass_form_uid,
          organization: { siret: '21340172201787' },
          applicant: hash_including(email: 'achats@saint-exemple.fr'),
          data: hash_including('delegue_protection_donnees_email' => 'dpo@saint-exemple.fr')
        )
      )
      expect(datapass).to have_received(:submit_demande).with('1001', consentement: { terms_of_service_accepted: true, data_protection_officer_informed: true })
      expect(editor_delegation_request.authorization_request.reload.external_id).to eq('1001')
    end

    it 'puts the request back to sign, with the reason, when DataPass refuses it' do
      allow(datapass).to receive(:submit_demande).and_raise(
        DatapassAPIClient::UnprocessableEntity.new('422', status: 422, errors: [{ 'detail' => 'Email du délégué à la protection des données n\'est pas délivrable' }])
      )

      visit editor_delegation_request.invitation_path
      fill_in_data_protection_officer
      click_on 'Continuer'
      consent
      perform_enqueued_jobs { click_on 'Soumettre la demande' }

      expect(editor_delegation_request.reload).not_to be_submitted

      visit editor_delegation_request.invitation_path

      expect(page).to have_text('DataPass a refusé une demande')
      expect(page).to have_text('n\'est pas délivrable')

      allow(datapass).to receive(:submit_demande).and_return({})
      click_on 'Continuer'
      consent
      perform_enqueued_jobs { click_on 'Soumettre la demande' }

      expect(page).to have_text('Votre demande d’habilitation est soumise')
      expect(editor_delegation_request.reload.datapass_error).to be_nil
      expect(datapass).to have_received(:create_demande).once
      expect(datapass).to have_received(:update_demande).with('1001', hash_including(:data))
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

      expect(page).to have_text('Soumettre vos 3 demandes')
      expect(page).to have_no_text('21030190500026')
      expect(page).to have_no_text('21030190500034')

      fill_in_data_protection_officer
      consent
      click_on 'Soumettre les 3 demandes'

      expect(page).to have_text('Vos demandes d’habilitation sont soumises')
      expect([editor_delegation_request, same_organization, other_organization].map(&:reload)).to all(be_submitted)
      expect([editor_delegation_request, same_organization, other_organization].map(&:delegue_protection_donnees_email)).to all(eq('dpo@saint-exemple.fr'))
      expect(already_submitted.reload.submitted_by_user).not_to eq(user)
      expect(of_another_contact.reload).not_to be_submitted
    end

    it 'leaves the excluded establishments pending' do
      visit editor_delegation_request.invitation_path

      fill_in_data_protection_officer
      uncheck 'Soumettre pour le SIRET 21340172200011'
      consent
      click_on 'Soumettre les 3 demandes'

      expect(page).to have_text('Vos demandes d’habilitation sont soumises')
      expect(page).to have_text('1 demande reste en attente de soumission')
      expect(editor_delegation_request.reload).to be_submitted
      expect(other_organization.reload).to be_submitted
      expect(same_organization.reload).not_to be_submitted

      click_on 'La soumettre maintenant'

      expect(page).to have_text('Soumettez la demande')
      expect(page).to have_field('Adresse électronique', with: 'dpo@saint-exemple.fr')
    end

    context 'when the editor provided the data protection officer of some organizations only' do
      let!(:other_organization) { create_request('21030190500018', :with_dpo) }

      it 'refuses to sign until every organization has its data protection officer' do
        visit editor_delegation_request.invitation_path

        expect(page).to have_text('À renseigner avant de soumettre')

        consent
        click_on 'Soumettre les 3 demandes'

        expect(page).to have_text('Renseignez le délégué à la protection des données')
        expect(editor_delegation_request.reload).not_to be_submitted

        click_on 'SIREN 213401722'
        fill_in_data_protection_officer(email: 'dpo@commune.fr')
        click_on 'Enregistrer'
        click_on 'Revenir aux demandes'

        consent
        click_on 'Soumettre les 3 demandes'

        expect(page).to have_text('Vos demandes d’habilitation sont soumises')
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
        allow(DatapassAPIClient).to receive(:new).and_return(instance_double(DatapassAPIClient).tap do |client|
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

      expect(page).to have_text('Votre demande d’habilitation est soumise')
      expect(page).to have_no_button('Soumettre la demande')
    end
  end

  context 'when the editor gave no contact email' do
    let(:editor_delegation_request) { create_request('21340172201787', contact_email: nil) }

    it 'offers no identification, since nobody could sign' do
      visit editor_delegation_request.invitation_path

      expect(page).to have_text('ne nous a pas transmis l\'adresse électronique du demandeur')
      expect(page).to have_no_button('login_pro_connect')
    end
  end
end
