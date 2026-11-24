class Admin::Editors::CaptureRecordAttributes < ApplicationInteractor
  def call
    context.admin_after_attributes = context.record.destroyed? ? {} : Admin::Editors::TrackedAttributes.of(context.record)
  end
end
