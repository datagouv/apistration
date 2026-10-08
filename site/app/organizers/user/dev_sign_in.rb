class User::DevSignIn < ApplicationOrganizer
  include SecurityEvent::Tracking

  tracks_security_event 'auth.login.attempted',
    target: :user,
    actor: ->(context) { SecurityEvent.actor_for(context.user) },
    details: { method: 'dev_login' }

  tracks_security_event_failures

  organize User::Login::FindUserByEmail,
    SecurityEvent::Track
end
