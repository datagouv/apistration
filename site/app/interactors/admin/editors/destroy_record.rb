class Admin::Editors::DestroyRecord < ApplicationInteractor
  def call
    context.record.destroy!
  end
end
