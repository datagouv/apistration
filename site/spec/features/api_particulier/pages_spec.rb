require 'rails_helper'

RSpec.describe 'Simple pages', app: :api_particulier do
  it_behaves_like 'static pages feature',
    check_root_content: true,
    check_newsletter_content: true,
    check_account_page: true,
    developers_content: 'Quotient familial',
    expected_api_name: 'API Particulier',
    unexpected_api_name: 'API Entreprise'

  it_behaves_like 'layout landmarks', %i[root_path cas_usages_path endpoints_path faq_index_path]

  context 'when authenticated' do
    let(:user) { create(:user, :with_token) }

    before { login_as(user) }

    it_behaves_like 'layout landmarks', %i[api_particulier_user_profile_path]
  end
end
