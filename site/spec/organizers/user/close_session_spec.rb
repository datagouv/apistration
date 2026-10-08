require 'rails_helper'

RSpec.describe User::CloseSession, type: :organizer do
  let(:user) { create(:user) }

  it 'emits a closed session security event with its reason' do
    expect { described_class.call(user:, reason: 'logout') }.to emit_security_event('auth.session.closed').with(
      target: { type: 'user', id: user.id },
      details: { reason: 'logout' }
    )
  end
end
