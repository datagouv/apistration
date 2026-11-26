RSpec.describe 'Editor delegation request journey on API Particulier', app: :api_particulier do
  include ActiveJob::TestHelper

  let(:editor_delegation_campaign) do
    create(:editor_delegation_campaign, api: 'particulier', datapass_form_uid: 'api-particulier-tarification-eaje', editor: create(:editor, name: 'Hoptis'), data: { 'intitule' => 'Tarification des crèches' })
  end
  let(:editor_delegation_request) do
    create(:editor_delegation_request, :with_authorization_request, :with_dpo, editor_delegation_campaign:, siret: '21340172201787', contact_email: 'creches@saint-exemple.fr')
  end
  let(:user) { create(:user, :with_full_name, email: 'creches@saint-exemple.fr') }

  let!(:datapass) { stub_datapass_formulaires }

  before do
    stub_cnil_data_protection_officers
    login_as(user)
  end

  it 'submits an API Particulier request, described with the labels of its DataPass definition' do
    visit editor_delegation_request.invitation_path
    click_on 'Continuer'

    expect(page).to have_text('Une demande d’habilitation à l’API Particulier')
    expect(page).to have_text('API Participation familiale EAJE')
    expect(page).to have_text('Allocataires')

    check 'terms_of_service_accepted'
    check 'data_protection_officer_informed'
    perform_enqueued_jobs { click_on 'Soumettre la demande' }

    expect(page).to have_text('Votre demande d’habilitation est soumise')
    expect(page).to have_text('en instruction chez API Particulier')
    expect(datapass).to have_received(:create_demande).with(hash_including(form_uid: 'api-particulier-tarification-eaje'))
  end

  it 'shows the convention the editor provided for each establishment, then sends it to DataPass with the request' do
    other_establishment = create(:editor_delegation_request, :with_authorization_request, :with_dpo, editor_delegation_campaign:, siret: '21340172200011', contact_email: user.email)
    [editor_delegation_request, other_establishment].each do |request|
      request.cadre_juridique_document.attach(io: Rails.root.join('spec/fixtures/files/convention.pdf').open, filename: "convention-#{request.siret}.pdf", content_type: 'application/pdf')
    end

    visit editor_delegation_request.invitation_path

    expect(page).to have_css('th', text: 'Convention')
    expect(page).to have_link('Voir', title: 'Convention de 21340172201787')

    click_on 'Continuer'
    click_link 'Voir', title: 'Convention de 21340172200011', match: :first

    expect(page.response_headers['Content-Type']).to eq('application/pdf')

    visit "#{editor_delegation_request.invitation_path}/verification"
    check 'terms_of_service_accepted'
    check 'data_protection_officer_informed'
    perform_enqueued_jobs { click_on 'Soumettre les 2 demandes' }

    expect(datapass).to have_received(:attach_documents).with('1001', 'cadre_juridique_document' => an_instance_of(ActiveStorage::Attached::One))
    expect(datapass).to have_received(:attach_documents).twice
  end

  it 'answers 404 to the link of an API Entreprise request' do
    entreprise_request = create(:editor_delegation_request, :with_authorization_request, contact_email: user.email)

    expect { visit entreprise_request.invitation_path }.to raise_error(ActionController::RoutingError)
  end
end
