class UnavailableForLegalReasonsError < AbstractGenericProviderError
  def subcode
    '005'
  end

  def kind
    :unavailable_for_legal_reason
  end
end
