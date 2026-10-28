class Admin::Impersonations::Start < ApplicationOrganizer
  include SecurityEvent::Tracking

  tracks_security_event 'auth.impersonation.started', target: :user, actor: ADMIN_ACTOR

  before do
    context.admin_activity_name = 'impersonation_started'
    context.admin_entity_key = :user
  end

  organize SecurityEvent::Track,
    Admin::TrackActivity
end
