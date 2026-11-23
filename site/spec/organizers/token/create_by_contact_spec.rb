RSpec.describe Token::CreateByContact do
  subject(:create_token) { described_class.call(authorization_request:, user: demandeur, name: 'Production', lifetime_in_months: 18) }

  let(:demandeur) { create(:user) }
  let(:authorization_request) do
    create(:authorization_request, :with_demandeur, demandeur:, status: 'validated', validated_at: 1.month.ago)
  end

  it 'emits the creation of the token by a contact' do
    expect { create_token }.to emit_security_event('token.api_token.created').with(
      target: { type: 'token', id: kind_of(String) },
      details: {
        source: 'contact',
        datapass_id: authorization_request.external_id,
        expires_at: Time.zone.at(18.months.from_now.to_i),
        scopes: authorization_request.scopes
      }
    )
  end

  it 'emits the IPs the token is restricted to with its creation' do
    restricted_creation = -> { described_class.call(authorization_request:, user: demandeur, name: 'Production', lifetime_in_months: 18, allowed_ips_text: "203.0.113.10\n198.51.100.0/24") }

    expect(&restricted_creation).to emit_security_event('token.api_token.created').with(
      details: hash_including(allowed_ips: contain_exactly('203.0.113.10/32', '198.51.100.0/24'))
    )
  end

  it 'refuses a creation once the demande has been revoked, even if it was allowed when the page was shown' do
    authorization_request.revoke!

    expect { create_token }.not_to change(Token, :count)
    expect(create_token).to be_a_failure
  end

  it 'emits no creation when the token is refused' do
    authorization_request.revoke!

    expect { create_token }.not_to emit_security_event('token.api_token.created')
  end
end
