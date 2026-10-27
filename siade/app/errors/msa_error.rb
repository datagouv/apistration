class MSAError < AbstractSpecificProviderError
  def initialize(kind, provider_error_meta = {})
    super(kind)
    @provider_error_meta = provider_error_meta
  end

  def provider_name
    'MSA'
  end

  def subcode_config
    {
      qf_calculation_impossible: '501'
    }
  end

  private

  def extra_meta
    @provider_error_meta
  end
end
