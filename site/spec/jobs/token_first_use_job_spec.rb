require 'rails_helper'

RSpec.describe TokenFirstUseJob do
  subject(:perform) { described_class.perform_now }

  let(:token) { create(:token, used: false, created_at: 1.hour.ago) }

  context 'when a token made its first calls' do
    before do
      create(:access_log, token:, timestamp: 3.minutes.ago)
      create(:access_log, token:, timestamp: 8.minutes.ago)
    end

    it 'emits the first use at the time of the earliest call, with the DataPass id' do
      expect { perform }.to emit_security_event('token.api_token.first_used').with(
        actor: { email: nil, role: 'api_client' },
        target: { type: 'token', id: token.id },
        details: { first_used_at: be_within(1.second).of(8.minutes.ago), datapass_id: token.authorization_request.external_id }
      )
    end

    it 'emits the first use only once' do
      events = SecurityEventRecorder.new.record do
        described_class.perform_now
        create(:access_log, token:)
        described_class.perform_now
      end

      expect(events.pluck(:event)).to eq(['token.api_token.first_used'])
    end

    it 'emits the first use even when the token was displayed as used before the job ran' do
      token.used?

      expect { perform }.to emit_security_event('token.api_token.first_used')
    end
  end

  it 'emits the first use of a token called 35 days ago and expired since' do
    expired_token = create(:token, used: false, created_at: 40.days.ago, exp: 20.days.ago.to_i)
    create(:access_log, token: expired_token, timestamp: 35.days.ago)

    expect { perform }.to emit_security_event('token.api_token.first_used').with(
      details: hash_including(first_used_at: be_within(1.second).of(35.days.ago))
    )
  end

  it 'emits nothing for a token never called' do
    token

    expect { perform }.not_to emit_security_event('token.api_token.first_used')
  end

  it 'emits nothing for a token already known as used before the tracking started' do
    create(:access_log, token: create(:token, used: true))

    expect { perform }.not_to emit_security_event('token.api_token.first_used')
  end
end
