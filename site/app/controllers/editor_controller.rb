class EditorController < ApplicationController
  include AuthenticatedUserManagement

  before_action :user_is_editor?
  before_action :editor_serves_current_api?
  helper_method :current_editor

  layout 'editor'

  protected

  def current_editor
    @current_editor ||= current_user.editor
  end

  private

  def user_is_editor?
    redirect_to_root unless current_user.editor?
  end

  def editor_serves_current_api?
    redirect_to_root unless current_editor.serves_api?(namespace)
  end
end
