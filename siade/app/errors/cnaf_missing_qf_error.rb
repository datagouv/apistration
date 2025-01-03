class CNAFMissingQFError < AbstractSpecificProviderError
  def provider_name
    'CNAF'
  end

  def subcode_config
    {
      missing_qf: '502'
    }
  end
end
