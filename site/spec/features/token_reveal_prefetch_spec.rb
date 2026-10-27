RSpec.describe 'Token reveal links hovered without a click', :js do
  def hover_and_let_the_browser_settle(*locator)
    find(*locator).hover
    sleep 0.3
    page.driver.wait_for_network_idle
  end

  describe 'a demandeur hovering the link to display a token', app: :api_particulier do
    let(:user) { create(:user, :demandeur) }
    let!(:authorization_request) { create(:authorization_request, :validated, demandeur_authorization_request_role: user.user_authorization_request_roles.first, api: 'particulier') }

    before do
      login_as(user)
      visit api_particulier_authorization_request_path(id: authorization_request.id)
    end

    it 'emits no token reveal' do
      expect { hover_and_let_the_browser_settle(:link, 'Voir le jeton') }.not_to emit_security_event('token.api_token.revealed')
    end
  end

  describe 'an editor hovering the link to the list of its authorization requests', app: :api_entreprise do
    let(:editor) { create(:editor, copy_token: true, form_uids: %w[form1]) }
    let(:user) { create(:user, editor:) }

    before do
      create(:authorization_request, :validated, api: 'entreprise', demarche: 'form1')
      login_as(user)
      visit editor_delegations_path
    end

    it 'emits no token reveal' do
      expect { hover_and_let_the_browser_settle(:link, 'vos habilitations') }.not_to emit_security_event('token.api_token.revealed')
    end
  end
end
