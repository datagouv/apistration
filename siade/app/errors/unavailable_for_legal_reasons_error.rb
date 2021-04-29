class UnavailableForLegalReasonsError < AbstractGenericProviderError
  attr_reader :message

  def subcode
    '005'
  end

  def kind
    :unavailable_for_legal_reason
  end

  def detail
    @message
  end
end
