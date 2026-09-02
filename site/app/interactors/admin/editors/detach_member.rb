class Admin::Editors::DetachMember < ApplicationInteractor
  def call
    context.user.update!(editor: nil)
  end
end
