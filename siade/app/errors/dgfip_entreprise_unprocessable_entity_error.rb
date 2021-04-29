class DGFIPEntrepriseUnprocessableEntityError < ApplicationError
  def initialize(message)
    @message = message
  end

  def title
    'Entité non traitable'
  end

  def code
    '03103'
  end

  def detail
    @message
  end

  def kind
    :provider_error
  end
end
