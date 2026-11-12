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

  def dashboard_modality_label(modality)
    t("provider.dashboard.modalities.names.#{modality}", default: modality.humanize)
  end

  def dashboard_share(count, total)
    return 0.0 if total.zero?

    (100.0 * count / total).round(2)
  end
end
