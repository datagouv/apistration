class Admin::Impersonations::Start < ApplicationOrganizer
  before do
    context.admin_activity_name = 'impersonation_started'
    context.admin_entity_key = :user
  end

  organize Admin::TrackActivity
end
