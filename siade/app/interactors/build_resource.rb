class BuildResource < ApplicationInteractor
  include ResourceHelpers

  class ResourceNotDefined < NotImplementedError; end

  def self.inherited(klass)
    klass.class_eval do
      after do
        context.resource.nil? &&
          resource_not_defined!
        context.meta = meta
      end
    end
  end

  def call
    context.resource = resource_klass.new(resource_attributes)
  end

  protected

  def meta
    {}
  end

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
end
