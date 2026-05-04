module ProviderDashboardHelper
  BUCKET_FORMATS = {
    'jour' => '%d/%m',
    'semaine' => 'S%V %G',
    'mois' => '%m/%Y'
  }.freeze

  def dashboard_bucket_label(bucket, interval)
    return bucket.to_s if bucket.blank?

    bucket.strftime(BUCKET_FORMATS.fetch(interval, '%d/%m/%Y'))
  end
end
