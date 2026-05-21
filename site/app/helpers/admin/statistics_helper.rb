module Admin::StatisticsHelper
  BUCKET_FORMATS = {
    'jour' => '%d/%m',
    'semaine' => 'S%V %G',
    'mois' => '%m/%Y'
  }.freeze

  def bucket_label(date, interval = 'mois')
    fmt = BUCKET_FORMATS.fetch(interval, '%d/%m/%Y')
    date.strftime(fmt)
  end
end
