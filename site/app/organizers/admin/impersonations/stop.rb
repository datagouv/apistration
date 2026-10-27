class Admin::Impersonations::Stop < ApplicationOrganizer
  include SecurityEvent::Tracking

  tracks_security_event 'auth.impersonation.stopped', target: :user, actor: ADMIN_ACTOR

  before do
    context.admin_activity_name = 'impersonation_stopped'
    context.admin_entity_key = :user
  end

  organize SecurityEvent::Track,
    Admin::TrackActivity
end
