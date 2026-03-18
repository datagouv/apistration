class ExpiredTokenError < UnauthorizedError
  def code
    '00103'
  end
end
