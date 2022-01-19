class BuildResourceCollection < ApplicationInteractor
  include ResourceHelpers

  class ResourceNotDefined < NotImplementedError; end
  class ResourceIdNotDefined < NotImplementedError; end

  def self.inherited(klass)
    super

    klass.class_eval do
      after do
        resource_not_defined! unless valid?(context.resource_collection)
        resource_id_not_defined! if context.resource_collection.any? { |resource| resource.id.nil? }
        context.meta = items_meta
      end
    end
  end

  def call
    context.resource_collection = items.map do |item|
      resource_klass.new(resource_attributes(item))
    end
  end

  protected

  def items
    raise NotImplementedError
  end

  def resource_attributes(item)
    raise NotImplementedError
  end

  def items_meta
    {}
  end

  def resource_klass
    Resource
  end

  private

  def valid?(collection)
    collection.present? && collection.is_a?(Array)
  end

  def resource_not_defined!
    raise ResourceNotDefined
  end

  def resource_id_not_defined!
    raise ResourceIdNotDefined
  end
end
