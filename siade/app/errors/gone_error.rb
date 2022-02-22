class GoneError < AbstractGenericProviderError
  attr_reader :provider_name

  def initialize(provider_name, message)
    @provider_name = provider_name
    @message = message
  end

  def subcode
    '007'
  end

  def title
    'Entité disparue'
  end

  def kind
    :gone
  end

  def detail
    @message
  end
end
