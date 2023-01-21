class BuildResourceCollection < ApplicationInteractor
  include ResourceHelpers

  class ResourceNotDefined < NotImplementedError; end

  def self.inherited(klass)
    klass.class_eval do
      around do |interactor|
        interactor.call unless staging?
      end

      after do
        resource_not_defined! unless resource_or_mock_data_valid?
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

  def resource_or_mock_data_valid?
    staging? ||
      valid?(context.bundled_data.data)
  end

  def resource_not_defined!
    raise ResourceNotDefined
  end
end
