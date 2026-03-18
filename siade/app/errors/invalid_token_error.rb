class InvalidTokenError < UnauthorizedError
  def code
    '00101'
  end
end
