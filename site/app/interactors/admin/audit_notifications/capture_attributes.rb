class Admin::AuditNotifications::CaptureAttributes < ApplicationInteractor
  def call
    context.admin_after_attributes = context.audit_notification.slice(
      'authorization_request_external_id',
      'reason',
      'approximate_volume'
    )
  end
end
