class User::ProconnectSignIn < ApplicationOrganizer
  include SecurityEvent::Tracking

  tracks_security_event 'auth.login.attempted',
    target: :user,
    actor: ->(context) { sign_in_actor(context) },
    details: { method: 'proconnect' },
    details_from_context: %i[idp mfa acr]

  tracks_security_event_failures

  organize User::Login::ValidateOAuthProvider,
    User::Login::ValidateOmniauthData,
    User::Login::ExtractProconnectIdentity,
    User::Login::EnsureMfa,
    User::ProconnectLogin,
    SecurityEvent::Track

  def self.sign_in_actor(context)
    return SecurityEvent.actor_for(context.user) if context.user

    SecurityEvent::ANONYMOUS_ACTOR.merge(email: context.user_params&.fetch('email', nil))
  end
end
