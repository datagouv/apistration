class BuildResourceCollection < ApplicationInteractor
  include ResourceHelpers

  class ResourceNotDefined < NotImplementedError; end
  class ResourceIdNotDefined < NotImplementedError; end

  def self.inherited(klass)
    super

    klass.class_eval do
      after { resource_not_defined! if context.resource_collection.nil? }
    end
  end

  def call
    resources = []

    resource_collection.each do |resource_attributes|
      resource_id_not_defined! if resource_attributes[:id].blank?

      resources << resource_klass.new(resource_attributes)
    end

    context.resource_collection = resources
  end

  protected

  def resource_attributes
    raise NotImplementedError
  end

  def resource_klass
    Resource
  end

  private

  def resource_not_defined!
    raise ResourceNotDefined
  end

  def resource_id_not_defined!
    raise ResourceIdNotDefined
  end
end
