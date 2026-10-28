RSpec.describe Token::CreateByContact do
  subject(:create_token) { described_class.call(authorization_request:, user: demandeur, name: 'Production', lifetime_in_months: 18) }

  let(:demandeur) { create(:user) }
  let(:authorization_request) do
    create(:authorization_request, :with_demandeur, demandeur:, status: 'validated', validated_at: 1.month.ago)
  end

  it 'refuses a creation once the demande has been revoked, even if it was allowed when the page was shown' do
    authorization_request.revoke!

    expect { create_token }.not_to change(Token, :count)
    expect(create_token).to be_a_failure
  end
end
