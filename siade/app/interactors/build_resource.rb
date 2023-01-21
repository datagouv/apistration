class BuildResource < ApplicationInteractor
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
    resource = resource_klass.new(resource_attributes)
    context.bundled_data = BundledData.new(data: resource, context: {})
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

  def resource_or_mock_data_valid?
    staging? ||
      context.bundled_data.present?
  end
end
