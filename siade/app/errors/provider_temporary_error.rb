class ProviderTemporaryError < ProviderInternalServerError
  def subcode
    '011'
  end
end
