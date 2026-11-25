RSpec.describe Token::ExtendByContact do
  include ActiveSupport::Testing::TimeHelpers

  subject(:extend_token) { described_class.call(token:, user: demandeur, lifetime_in_months:) }

  let(:demandeur) { create(:user) }
  let(:authorization_request) do
    create(:authorization_request, :with_demandeur, demandeur:, status: 'validated', validated_at: 1.month.ago)
  end
  let(:token) { create(:token, authorization_request:, exp: 80.days.from_now.to_i) }

  context 'when the chosen lifetime ends after the current expiration' do
    let(:lifetime_in_months) { 6 }

    it 'extends the token' do
      expect(extend_token).to be_a_success
      expect(Time.zone.at(token.reload.exp)).to be_within(1.minute).of(6.months.from_now)
    end

    it 'emits the prolongation of the token by a contact' do
      expect { extend_token }.to emit_security_event('token.api_token.prolonged').with(
        target: { type: 'token', id: token.id },
        details: {
          source: 'contact',
          datapass_id: authorization_request.external_id,
          expires_at: be_within(1.minute).of(6.months.from_now)
        }
      )
    end
  end

  context 'when the chosen lifetime would end before the current expiration' do
    let(:lifetime_in_months) { 3 }
    let(:token) { create(:token, authorization_request:, exp: Time.zone.local(2027, 5, 1, 12).to_i) }

    before { travel_to(Time.zone.local(2027, 1, 31, 12)) }

    after { travel_back }

    it 'refuses to shorten the token, three months from January 31st ending on April 30th' do
      expect { extend_token }.not_to(change { token.reload.exp })
      expect(extend_token).to be_a_failure
    end

    it 'emits no prolongation' do
      expect { extend_token }.not_to emit_security_event('token.api_token.prolonged')
    end
  end
end
