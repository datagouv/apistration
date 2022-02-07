class RecipientAndResourceIdIdenticalError < UnprocessableEntityError
  def initialize
    super(:recipient)
  end

  def code
    '00211'
  end
end
