class Documents::RetrieveFromUrl < ApplicationInteractor
  before do
    context.errors ||= []
  end

  # rubocop:disable Metrics/AbcSize, Metrics/MethodLength
  def call
    context.content = URI.open(source_url).binmode.read
  rescue OpenURI::HTTPError => e
    response = e.io
    msg = "Erreur lors de la récupération du document : status #{response.status[0]} with body '#{response.string}'"
    fail_with_error(:http_error, msg)
  rescue Net::OpenTimeout, Net::ReadTimeout, EOFError
    fail_with_error(:timeout_error, 'Temps d\'attente de téléchargement du document écoulé')
  rescue URI::InvalidURIError => e
    msg = "L'URL source du document chez le fournisseur de données est invalide : #{e.message}."
    fail_with_error(:invalid_url, msg)
  rescue OpenSSL::SSL::SSLError => e
    log_warning('Documents::RetrieveFromUrl: OpenSSL Error while opening URI', e)

    context.content = URI.open(source_url, { ssl_verify_mode: OpenSSL::SSL::VERIFY_NONE }).binmode.read
  rescue StandardError => e
    log_error('Documents::RetrieveFromUrl: PDF upload/read unknown error', e)

    errors << UnknownError.new
    context.fail!
  end
  # rubocop:enable Metrics/AbcSize, Metrics/MethodLength

  private

  def fail_with_error(kind, msg)
    errors << BadFileFromProviderError.new(context.provider_name, kind, msg)
    context.fail!
  end

  def errors
    context.errors
  end

  def source_url
    URI.parse(context.url)
  end

  def log_error(message, exception)
    log_event(
      'error',
      message,
      {
        exception: exception.message,
        url: source_url,
        host: source_url.host
      }
    )
  end

  def log_warning(message, exception)
    log_event(
      'warning',
      message,
      {
        exception: exception.message,
        url: source_url,
        host: source_url.host
      }
    )
  end

  def log_event(level, message, context)
    MonitoringService.instance.track(
      level,
      message,
      context
    )
  end
end
