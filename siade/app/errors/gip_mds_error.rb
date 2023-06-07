class GIPMDSError < AbstractSpecificProviderError
  def provider_name
    'GIP-MDS'
  end

  def subcode_config
    {
      ko_technique: '501'
    }
  end
end
