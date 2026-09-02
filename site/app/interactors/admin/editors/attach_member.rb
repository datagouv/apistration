class Admin::Editors::AttachMember < ApplicationInteractor
  def call
    context.user.update!(editor: context.editor)
  end
end
