class Admin::TrackActivity < ApplicationInteractor
  def call
    AdminActivity.create!(
      name: context.admin_activity_name,
      admin: context.admin,
      namespace: context.namespace,
      entity:,
      before_attributes:,
      after_attributes:
    )
  end

  private

  def entity
    return if context.admin_entity_key.blank?

    context.public_send(context.admin_entity_key)
  end

  def before_attributes
    context.admin_before_attributes || {}
  end

  def after_attributes
    return context.admin_after_attributes if context.admin_after_attributes

    before_attributes.keys.index_with { |key| entity.public_send(key) }
  end
end
