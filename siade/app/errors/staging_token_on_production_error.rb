class StagingTokenOnProductionError < UnauthorizedError
  attr_reader :api_kind

  def initialize(api_kind = nil)
    @api_kind = api_kind
  end

  def code
    '00109'
  end

  def detail
    super[api_kind] || super['default']
  end
end
