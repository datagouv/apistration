class NotImplementedYetError < ApplicationError
  def code
    '00503'
  end

  def kind
    :internal_error
  end
end
