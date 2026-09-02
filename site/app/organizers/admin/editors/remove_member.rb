class Admin::Editors::RemoveMember < ApplicationOrganizer
  before do
    context.admin_activity_name = 'editor_member_removed'
    context.admin_entity_key = :user
  end

  organize Admin::Editors::FindMember,
    Admin::Editors::CaptureMemberAttributes,
    Admin::Editors::DetachMember,
    Admin::TrackActivity
end
