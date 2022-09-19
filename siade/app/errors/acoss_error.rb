class ACOSSError < AbstractSpecificProviderError
  def provider_name
    'ACOSS'
  end

  def extra_meta
    return {} unless @kind == :manual_verification_asked

    {
      retry_in: 2.days.to_i
    }
  end

  def subcode_config
    {
      manual_verification_asked: '501',
      ongoing_manual_verification: '502',
      cannot_deliver_document: '503',
    }
  end

  def meta
    super.merge(extra_meta)
  end
end
