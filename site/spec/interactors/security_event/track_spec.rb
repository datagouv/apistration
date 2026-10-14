require 'rails_helper'

RSpec.describe SecurityEvent::Track, type: :interactor do
  let(:user) { create(:user) }

  before do
    stub_const('TrackedSignIn', Class.new(ApplicationOrganizer) do
      include SecurityEvent::Tracking

      tracks_security_event 'auth.login.attempted',
        target: :user,
        details: { method: 'proconnect' },
        details_from_context: %i[idp],
        failures: true

      organize SecurityEvent::Track
    end)

    stub_const('DeniedSignIn', Class.new(ApplicationOrganizer) do
      include SecurityEvent::Tracking

      tracks_security_event 'auth.login.attempted',
        target: :user,
        actor: ->(context) { SecurityEvent::ANONYMOUS_ACTOR.merge(email: context.email) },
        details: { method: 'proconnect' },
        details_from_context: %i[acr],
        failures: true

      organize(Class.new(ApplicationInteractor) do
        def call
          context.acr = 'eidas1'
          context.fail!(message: 'mfa_missing')
        end
      end, SecurityEvent::Track)
    end)

    stub_const('UntrackedFailure', Class.new(ApplicationOrganizer) do
      include SecurityEvent::Tracking

      tracks_security_event 'auth.session.closed', target: :user

      organize(Class.new(ApplicationInteractor) do
        def call
          context.fail!(message: 'nope')
        end
      end, SecurityEvent::Track)
    end)
  end

  after { Rails.event.clear_context }

  it 'emits the declared event on the target found in the context' do
    expect { TrackedSignIn.call(user:) }.to emit_security_event('auth.login.attempted').with(
      target: { type: 'user', id: user.id },
      details: { method: 'proconnect' }
    )
  end

  it 'adds the declared context values to the details' do
    expect { TrackedSignIn.call(user:, idp: 'idp-uuid', acr: 'undeclared') }.to emit_security_event('auth.login.attempted').with(
      details: { method: 'proconnect', idp: 'idp-uuid' }
    )
  end

  it 'uses the request actor unless the organizer resolves one' do
    SecurityEvent.set_request_context(user:, true_user: user)

    expect { TrackedSignIn.call(user: nil) }.to emit_security_event('auth.login.attempted').with(
      actor: { email: user.email, role: 'user' },
      target: { type: 'user', id: nil }
    )
  end

  context 'when the organizer tracks its failures' do
    it 'emits a denied event with the failure reason' do
      expect { DeniedSignIn.call(email: 'attempt@example.com') }.to emit_security_event('auth.login.attempted').with(
        actor: { email: 'attempt@example.com', role: 'anonymous' },
        target: { type: 'user', id: nil },
        details: { method: 'proconnect', acr: 'eidas1', reason: 'mfa_missing', outcome: 'denied' }
      )
    end

    it 'emits once on failure' do
      expect(SecurityEventRecorder.new.record { DeniedSignIn.call(email: 'attempt@example.com') }.size).to eq(1)
    end

    it 'emits once on success' do
      expect(SecurityEventRecorder.new.record { TrackedSignIn.call(user:) }.size).to eq(1)
    end

    it 'still fails' do
      expect(DeniedSignIn.call(email: 'attempt@example.com')).to be_a_failure
    end
  end

  context 'when the organizer does not track its failures' do
    it 'emits nothing on failure' do
      expect { UntrackedFailure.call(user:) }.not_to emit_security_event('auth.session.closed')
    end
  end

  it 'exposes the event declared by each organizer' do
    expect(TrackedSignIn.security_event_name).to eq('auth.login.attempted')
  end
end
