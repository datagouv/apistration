require 'rails_helper'

RSpec.describe 'Simple pages', app: :api_entreprise do
  it_behaves_like 'static pages feature',
    developers_content: 'siret',
    expected_api_name: 'API Entreprise'

  it_behaves_like 'layout landmarks', %i[root_path cas_usages_path endpoints_path faq_index_path]

  context 'when authenticated' do
    let(:user) { create(:user) }

    before { login_as(user) }

    it_behaves_like 'layout landmarks', %i[authorization_requests_path]
  end
end
