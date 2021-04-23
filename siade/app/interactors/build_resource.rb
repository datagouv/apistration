class BuildResource < ApplicationInteractor
  include ResourceHelpers

  class ResourceNotDefined < NotImplementedError; end

  def self.inherited(klass)
    klass.class_eval do
      after do
        if context.resource.nil?
          resource_not_defined!
        end
      end
    end
  end

  def call
    fail 'should be implemented in inherited class'
  end

  def resource_not_defined!
    raise ResourceNotDefined
  end
end
