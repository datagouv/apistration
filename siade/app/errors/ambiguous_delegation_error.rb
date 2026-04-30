class AmbiguousDelegationError < ApplicationError
  def code
    '00212'
  end

  def kind
    :wrong_parameter
  end
end
