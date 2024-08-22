class ExpiredLinkError < ApplicationError
  attr_reader :message

  def initialize(message = nil)
    @message = message
  end

  def title
    'Lien expiré'
  end

  def code
    '00403'
  end

  def kind
    :gone
  end
end
