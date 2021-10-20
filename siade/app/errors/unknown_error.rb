class UnknownError < ApplicationError
  def code
    '00500'
  end

  def kind
    :internal_error
  end
end
