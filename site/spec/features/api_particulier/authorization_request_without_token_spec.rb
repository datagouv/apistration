RSpec.describe 'displays show of an authorization request without token', app: :api_particulier do
  let!(:user) { create(:user) }
  let!(:authorization_request) do
    create(
      :authorization_request,
      :with_demandeur,
      demandeur: user,
      api: 'particulier',
      status: 'validated'
    )
  end

  before do
    login_as(user)
    visit api_particulier_authorization_request_path(id: authorization_request.id)
  end

  it 'displays the authorization request with no token state' do
    expect(page).to have_current_path(api_particulier_authorization_request_path(id: authorization_request.id), ignore_query: true)
    expect(page).to have_text(authorization_request.intitule)
    expect(page).to have_css('#habilitation_no_token')
    expect(page).to have_css('#contact_demandeur_its_me')
    expect(page).to have_no_css('#prolong-token-modal-link')
    expect(page).to have_no_css('#renew-token-modal-link')
    expect(page).not_to expose_window_opener
    expect(page).to have_link(id: 'renew-authorization-request-link', href: datapass_reopen_authorization_request_url(authorization_request))
  end
end
