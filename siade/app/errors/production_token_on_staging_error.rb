class ProductionTokenOnStagingError < UnauthorizedError
  def code
    '00108'
  end
end
