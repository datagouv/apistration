class TokenNotFoundError < UnauthorizedError
  def code
    '00106'
  end
end
