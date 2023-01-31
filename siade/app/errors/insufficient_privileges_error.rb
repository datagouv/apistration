class InsufficientPrivilegesError < ForbiddenError
  attr_reader :api_kind

  def initialize(api_kind)
    @api_kind = api_kind
  end

  def code
    '00100'
  end

  def detail
    super[api_kind]
  end
end
