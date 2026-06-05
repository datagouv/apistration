class Admin::Users::Update < ApplicationOrganizer
  before do
    context.admin_activity_name = 'user_updated'
    context.admin_entity_key = :user
    context.admin_before_attributes = context.user.slice('editor_id', 'provider_uids')
  end

  organize Admin::Users::UpdateModel,
    Admin::TrackActivity
end
