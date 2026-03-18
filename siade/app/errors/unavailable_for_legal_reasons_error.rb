class UnavailableForLegalReasonsError < AbstractGenericProviderError
  attr_reader :message

  def subcode
    '005'
  end

  def detail
    @message
  end
end
