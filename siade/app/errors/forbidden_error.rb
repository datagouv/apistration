class ForbiddenError < ApplicationError
  def code
    raise 'It should be override in inherited classes'
  end

  def kind
    :forbidden
  end
end
