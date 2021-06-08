class AbstractGenericProviderError < ApplicationError
  class UnknownProviderCode < StandardError; end

  attr_reader :provider_name

  def initialize(provider_name, message=nil)
    @provider_name = provider_name
    @message = message
  end

  def add_meta(meta)
    extra_meta.merge!(meta)
    self
  end

  def code
    "#{provider_code}#{subcode}"
  end

  def subcode
    raise 'It should be override in inherited classes'
  end

  def meta
    {
      provider: provider_name,
    }.merge(extra_meta)
  end

  def detail
    @message || super
  end

  def extra_meta
    @extra_meta ||= {}
  end

  def kind
    :provider_error
  end

  def error_entry
    errors_backend.get(subcode) || {}
  end

  def provider_code
    errors_backend.provider_code_from_name(provider_name) ||
      (raise UnknownProviderCode)
  end
end
