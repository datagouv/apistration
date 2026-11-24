class Admin::Editors::UpdateRecord < ApplicationInteractor
  def call
    context.fail!(message: context.record.errors.full_messages.to_sentence) unless context.record.update(context.record_params)
  end
end
