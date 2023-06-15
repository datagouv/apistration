class GIPMDSError < AbstractSpecificProviderError
  def provider_name
    'GIP-MDS'
  end

  def subcode_config
    {
      ko_technique: '501',
      temporary_credentials_error: '502'
    }
  end

  private

  def extra_meta
    if @kind == :temporary_credentials_error
      {
        retry_in: 10
      }
    else
      super
    end
  end
end
