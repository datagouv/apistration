class GIPMDSError < AbstractSpecificProviderError
  RETRY_IN_WITHOUT_DATE = 3600

  def initialize(kind, retry_date = nil)
    super(kind)
    @retry_date = retry_date
  end

  def provider_name
    'GIP-MDS'
  end

  def subcode_config
    {
      ko_technique: '501',
      temporary_credentials_error: '502',
      quota_error: '503'
    }
  end

  private

  def extra_meta
    if @kind == :temporary_credentials_error
      {
        retry_in: 10
      }
    elsif @kind == :quota_error
      {
        retry_in: quota_retry_in
      }
    else
      super
    end
  end

  def quota_retry_in
    return RETRY_IN_WITHOUT_DATE if @retry_date.nil?

    @retry_date.to_i - Time.zone.now.to_i
  end
end
