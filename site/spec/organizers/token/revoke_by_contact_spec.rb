RSpec.describe Token::RevokeByContact do
  include ActiveJob::TestHelper

  subject(:revoke_token) { described_class.call(token:, user: demandeur) }

  let(:demandeur) { create(:user) }
  let(:authorization_request) do
    create(:authorization_request, :with_demandeur, :with_contact_technique, demandeur:, status: 'validated', validated_at: 1.month.ago)
  end
  let(:token) { create(:token, authorization_request:, name: 'Recette') }

  it 'does not revoke nor notify twice a token already revoked' do
    described_class.call(token:, user: demandeur)

    expect { revoke_token }.not_to(change { token.reload.blacklisted_at })
    expect(revoke_token).to be_a_failure
    expect(enqueued_jobs.size).to eq(1)
  end
end
