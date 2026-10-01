class ANTSError < AbstractSpecificProviderError
  def provider_name
    'ANTS'
  end

  def kind
    :not_found
  end

  protected

  def subcode_config
    {
      no_matching_identity: '404'
    }
  end
end
