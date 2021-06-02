class BuildResource < ApplicationInteractor
  include ResourceHelpers

  class ResourceNotDefined < NotImplementedError; end
  class ResourceIdNotDefined < NotImplementedError; end

  def self.inherited(klass)
    klass.class_eval do
      after do
        if context.resource.nil?
          resource_not_defined!
        elsif context.resource.id.blank?
          resource_id_not_defined!
        end
      end
    end
  end

  def call
    context.resource = resource_klass.new(resource_attributes)
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
