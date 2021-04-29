class BadRequestError < ApplicationError
  attr_reader :message

  def initialize(message=nil)
    @message = message
  end

  def detail
    detail = 'Votre requête est invalide'
    detail = "#{detail}: #{message}" if message
    detail
  end

  def title
    'Mauvaise requête'
  end

  def code
    '00401'
  end

  def kind
    :bad_request
  end
end
