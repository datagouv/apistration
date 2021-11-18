class OpenAPIExampleError < ApplicationError
  def code
    '00104'
  end

  def kind
    :internal_error
  end
end
