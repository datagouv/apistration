class UnsupportedAPIVersionError < ApplicationError
  def initialize(invalid_value)
    @invalid_value = invalid_value
  end

  def detail
    "La version #{@invalid_value} n'est pas supportée pour ce endpoint."
  end

  def code
    '00402'
  end

  def kind
    :not_found
  end
end
