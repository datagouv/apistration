RSpec.describe 'Editor: token generation', app: :api_entreprise do
  include ActiveJob::TestHelper

  let(:editor) { create(:editor, name: 'Logiciel Mairie', copy_token: true, form_uids: ['logiciel-mairie']) }
  let(:editor_user) { create(:user, editor:) }
  let!(:authorization_request) do
    create(:authorization_request, :with_all_contacts, demarche: 'logiciel-mairie', status: 'validated', validated_at: 1.day.ago, intitule: 'Mairie de Lyon')
  end

  before { login_as(editor_user) }

  it 'lets an editor copying tokens generate one for a demande without active token, and tells its contacts' do
    visit editor_authorization_requests_path

    perform_enqueued_jobs { click_on 'Générer un jeton' }

    token = authorization_request.tokens.sole
    expect(token.name).to eq('Jeton Logiciel Mairie')
    expect(token.creator).to eq(editor_user)
    expect(page).to have_css("##{dom_id(token, :copy_token_button)}")
    expect(ActionMailer::Base.deliveries.last.to).to match_array(authorization_request.users.map(&:email))
  end

  it 'copies the most recent active token instead of generating one' do
    create(:token, authorization_request:, name: 'Ancien', created_at: 2.days.ago)
    recent = create(:token, authorization_request:, name: 'Récent')

    visit editor_authorization_requests_path

    expect(page).to have_css("##{dom_id(recent, :copy_token_button)}")
    expect(page).to have_no_button('Générer un jeton')
  end

  context 'when the editor does not copy tokens' do
    let(:editor) { create(:editor, copy_token: false, form_uids: ['logiciel-mairie']) }

    it 'does not offer the generation' do
      visit editor_authorization_requests_path

      expect(page).to have_css("##{dom_id(authorization_request)}")
      expect(page).to have_no_button('Générer un jeton')
    end
  end
end
