class InvalidRecipientError < UnprocessableEntityError
  def self.build_example(**)
    new
  end

  def initialize
    super(:recipient)
  end

  def code
    '00210'
  end
end
