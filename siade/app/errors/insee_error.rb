class INSEEError < AbstractSpecificProviderError
  def provider_name
    'INSEE'
  end

  def subcode_config
    {
      more_than_one_siege: '501'
    }
  end
end
