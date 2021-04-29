class RetrieverOrganizer < ApplicationOrganizer
  class InvalidProviderName < StandardError; end

  def self.inherited(klass)
    klass.class_eval do
      before do
        context.provider_name = provider_name
        invalid_provider_name! unless provider_name_valid?
        context.resource = nil
        context.errors   = []
      end
    end
  end

  def provider_name
    fail 'should be implemented in inherited class'
  end

  def invalid_provider_name!
    raise InvalidProviderName
  end

  def provider_name_valid?
    ErrorsBackend.instance.provider_code_from_name(context.provider_name).present?
  end
end
