class TooManyRequestsError < ApplicationError
  def title
    'Trop de requêtes'
  end

  def detail
    'Vous avez effectué trop de requêtes'
  end

  def code
    '00429'
  end
end
