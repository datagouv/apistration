class UnknownOperationError < ApplicationError
  attr_reader :operation_id

  def initialize(operation_id)
    @operation_id = operation_id
  end

  def code
    '00404'
  end

  def detail
    "#{super} (#{operation_id})"
  end

  def kind
    :not_found
  end
end
