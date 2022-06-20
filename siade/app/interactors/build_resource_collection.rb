class BuildResourceCollection < ApplicationInteractor
  include ResourceHelpers

  class ResourceNotDefined < NotImplementedError; end

  def self.inherited(klass)
    super

    klass.class_eval do
      after do
        resource_not_defined! unless valid?(context.bundled_data.data)
      end
    end
  end

  def call
    resource_collection = items.map do |item|
      resource_klass.new(resource_attributes(item))
    end

    context.bundled_data = BundledData.new(data: resource_collection, context: items_context)
  end

  protected

  def items
    raise NotImplementedError
  end

  def items_context
    {}
  end

  def resource_attributes(item)
    raise NotImplementedError
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
end
