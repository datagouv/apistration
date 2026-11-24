class Admin::Editors::CreateRecord < ApplicationInteractor
  def call
    record = context.editor.public_send(context.association).build(context.record_params)
    context.record = record

    context.fail!(message: record.errors.full_messages.to_sentence) unless record.save
  end
end
