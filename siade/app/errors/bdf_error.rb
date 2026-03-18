class BDFError < AbstractSpecificProviderError
  def provider_name
    'Banque de France'
  end

  def subcode_config
    {
      bdd_error:      '501',
      internal_error: '502',
    }
  end
end
