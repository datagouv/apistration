class ForbiddenIpError < ForbiddenError
  attr_reader :api

  def initialize(api = nil)
    @api = api
  end

  def code
    '00107'
  end
end
