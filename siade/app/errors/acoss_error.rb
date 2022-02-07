class ACOSSError < AbstractSpecificProviderError
  def provider_name
    'ACOSS'
  end

  def extra_meta
    return {} unless @kind == :ongoing_manual_verification

    {
      retry_in: 2.days.to_i
    }
  end

  def subcode_config
    {
      ongoing_manual_verification: '501'
    }
  end

  def meta
    super.merge(extra_meta)
  end
end
