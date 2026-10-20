class Admin::Editors::UpdateModel < ApplicationInteractor
  def call
    context.editor.assign_attributes(context.editor_params)
    context.fail! unless context.editor.save(context: :admin_form)
  end
end
