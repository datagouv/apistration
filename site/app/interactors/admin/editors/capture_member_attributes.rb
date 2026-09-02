class Admin::Editors::CaptureMemberAttributes < ApplicationInteractor
  def call
    context.admin_before_attributes = context.user.slice('email', 'editor_id')
  end
end
