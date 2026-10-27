class User::CloseSession < ApplicationOrganizer
  include SecurityEvent::Tracking

  tracks_security_event 'auth.session.closed', target: :user, details_from_context: %i[reason]

  organize SecurityEvent::Track
end
