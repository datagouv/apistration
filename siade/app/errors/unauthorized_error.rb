class UnauthorizedError < ApplicationError
  def code
    raise 'It should be override in inherited classes'
  end

  def kind
    :unauthorized
  end
end
