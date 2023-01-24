class BuildResourceCollection < ApplicationInteractor
  include ResourceHelpers

  class ResourceNotDefined < NotImplementedError; end

  def self.inherited(klass)
    klass.class_eval do
      around do |interactor|
        interactor.call unless staging?
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
end
