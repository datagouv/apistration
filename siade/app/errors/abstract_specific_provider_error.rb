class AbstractSpecificProviderError < ApplicationError
  def initialize(kind)
    @kind = kind.to_sym
  end

  def subcode
    subcode_config.fetch(@kind) do
      raise KeyError, "#{@kind} is not a valid kind name"
    end
  end

  def provider_name
    raise 'It should be override in inherited classes'
  end

  def code
    "#{provider_code}#{subcode}"
  end

  def meta
    {
      provider: provider_name
    }
  end

  def kind
    :provider_error
  end

  protected

  def subcode_config
    raise 'It should be override in inherited classes'
  end

  private

  def provider_code
    errors_backend.provider_code_from_name(provider_name) ||
      (raise 'Invalid provider name')
  end
end
