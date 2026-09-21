class InvalidTokenError < UnauthorizedError
  DEFAULT_REASON = :invalid

  attr_reader :reason

  def initialize(reason = DEFAULT_REASON)
    @reason = reason
  end

  def code
    '00101'
  end

  def detail
    super[reason.to_s] || super[DEFAULT_REASON.to_s]
  end
end
