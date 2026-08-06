class ProviderUnknownError < AbstractGenericProviderError
  def initialize(provider_name, message = nil, subcode: '999')
    super(provider_name, message)
    @subcode = subcode
  end

  attr_reader :subcode

  def tracking_level
    'error'
  end

  def kind
    :provider_unknown_error
  end
end
