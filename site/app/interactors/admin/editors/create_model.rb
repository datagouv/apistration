class Admin::Editors::CreateModel < ApplicationInteractor
  def call
    context.editor = Editor.new(context.editor_params)
    context.fail! unless context.editor.save
  end
end
