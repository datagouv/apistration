class InsufficientPrivilegesError < ForbiddenError
  def code
    '00100'
  end
end
