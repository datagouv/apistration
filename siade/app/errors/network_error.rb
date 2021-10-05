class NetworkError < ApplicationError
  def code
    '00501'
  end

  def kind
    :network_error
  end
end
