class Admin::Editors::CaptureFormUids < ApplicationInteractor
  def call
    context.form_uids_before = context.editor.form_uids
  end
end
