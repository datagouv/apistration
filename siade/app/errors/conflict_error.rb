class ConflictError < AbstractGenericProviderError
  def subcode
    '015'
  end

  def detail
    @message || super
  end

  def kind
    :conflict
  end
end
