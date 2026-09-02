class Admin::Editors::AddMember < ApplicationOrganizer
  before do
    context.admin_activity_name = 'editor_member_added'
    context.admin_entity_key = :user
  end

  organize Admin::Editors::FindFutureMember,
    Admin::Editors::CaptureMemberAttributes,
    Admin::Editors::AttachMember,
    Admin::TrackActivity
end
