class OldTokenError < UnauthorizedError
  def code
    '00102'
  end
end
