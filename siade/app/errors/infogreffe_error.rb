class InfogreffeError < AbstractSpecificProviderError
  def provider_name
    'Infogreffe'
  end

  def subcode_config
    {
      temporary_credentials_error: '501'
    }
  end

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
