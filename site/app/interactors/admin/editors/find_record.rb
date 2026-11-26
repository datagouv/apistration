class Admin::Editors::FindRecord < ApplicationInteractor
  def call
    record = context.editor.public_send(context.association).find(context.record_id)
    context.record = record
    context.admin_before_attributes = Admin::Editors::TrackedAttributes.of(record)
  rescue ActiveRecord::RecordNotFound
    context.fail!(message: 'Élément introuvable')
  end
end
