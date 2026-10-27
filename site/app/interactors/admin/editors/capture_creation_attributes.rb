class Admin::Editors::CaptureCreationAttributes < ApplicationInteractor
  def call
    context.admin_after_attributes = Admin::Editors::TrackedAttributes.of(context.editor)
  end
end
