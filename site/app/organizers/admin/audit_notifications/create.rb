class Admin::AuditNotifications::Create < ApplicationOrganizer
  before do
    context.admin_activity_name = 'audit_notification_created'
    context.admin_entity_key = :audit_notification
  end

  organize Admin::AuditNotifications::CreateModel,
    Admin::AuditNotifications::SendEmail,
    Admin::AuditNotifications::CaptureAttributes,
    Admin::TrackActivity
end
