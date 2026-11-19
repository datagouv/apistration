RSpec.describe 'Prolongation links sent before the switch', app: :api_entreprise do
  let(:user) { create(:user) }
  let(:authorization_request) { create(:authorization_request, :with_demandeur, demandeur: user, status: 'validated', validated_at: 1.month.ago) }
  let(:token) { create(:token, authorization_request:) }

  before { login_as(user) }

  [
    ->(token) { "/compte/jetons/#{token.id}/demarche_prolongation" },
    ->(token) { "/compte/jetons/#{token.id}/demarche_prolongation/owner" },
    ->(token) { "/compte/jetons/#{token.id}/demarche_prolongation/finished" },
    ->(token) { "/compte/jetons/#{token.id}/demande-prolongation" },
    ->(token) { "/compte/jetons/#{token.id}/renew" }
  ].each_with_index do |legacy_path, index|
    it "lead to the page of the demande (link #{index + 1})" do
      visit legacy_path.call(token)

      expect(page).to have_current_path(authorization_request_path(authorization_request))
    end
  end
end
