class DSNJError < AbstractSpecificProviderError
  def provider_name
    'DSNJ'
  end

  def subcode_config
    {
      irrelevant_age: '400'
    }
  end

  def kind
    :wrong_parameter
  end
end
