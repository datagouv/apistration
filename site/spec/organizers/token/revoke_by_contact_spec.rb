RSpec.describe Token::RevokeByContact do
  include ActiveJob::TestHelper

  subject(:revoke_token) { described_class.call(token:, user: demandeur) }

  let(:demandeur) { create(:user) }
  let(:authorization_request) do
    create(:authorization_request, :with_demandeur, :with_contact_technique, demandeur:, status: 'validated', validated_at: 1.month.ago)
  end
  let(:token) { create(:token, authorization_request:, name: 'Recette') }

  it 'emits the revocation of the token by a contact' do
    expect { revoke_token }.to emit_security_event('token.api_token.revoked').with(
      target: { type: 'token', id: token.id },
      details: { datapass_id: authorization_request.external_id, blacklisted_at: be_within(1.minute).of(Time.zone.now) }
    )
  end

  it 'emits no second revocation for a token already revoked' do
    described_class.call(token:, user: demandeur)

    expect { revoke_token }.not_to emit_security_event('token.api_token.revoked')
  end

  it 'does not revoke nor notify twice a token already revoked' do
    described_class.call(token:, user: demandeur)

    expect { revoke_token }.not_to(change { token.reload.blacklisted_at })
    expect(revoke_token).to be_a_failure
    expect(enqueued_jobs.size).to eq(1)
  end
end
