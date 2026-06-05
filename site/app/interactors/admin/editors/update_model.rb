class Admin::Editors::UpdateModel < ApplicationInteractor
  def call
    context.fail! unless context.editor.update(context.editor_params)
  end
end
