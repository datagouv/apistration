class InvalidRecipientError < UnprocessableEntityError
  def initialize
    super(:recipient)
  end

  def code
    '00210'
  end
end
