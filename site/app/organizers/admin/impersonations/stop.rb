class Admin::Impersonations::Stop < ApplicationOrganizer
  before do
    context.admin_activity_name = 'impersonation_stopped'
    context.admin_entity_key = :user
  end

  organize Admin::TrackActivity
end
