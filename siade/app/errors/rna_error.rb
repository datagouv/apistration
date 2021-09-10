class RNAError < AbstractSpecificProviderError
  def provider_name
    'RNA'
  end

  def subcode_config
    {
      incorrect_xml: '501'
    }
  end
end
