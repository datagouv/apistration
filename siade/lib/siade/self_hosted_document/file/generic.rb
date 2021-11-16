class SIADE::SelfHostedDocument::File::Generic
  attr_reader :file_label, :errors

  def initialize(file_label)
    @file_label = file_label
    @doc_uploader = SIADE::SelfHostedDocument::Uploader
    @errors = []
  end

  def store_from_binary(bin)
    @binary = bin
    perform
  end

  def store_from_base64(content)
    @binary = Base64.strict_decode64(content)
    perform
  rescue ArgumentError
    error_message(:invalid_base64, 'Erreur lors du décodage : invalide Base64 format')
  end

  # rubocop:disable Metrics/AbcSize, Metrics/MethodLength
  def store_from_url(url)
    @binary = URI.open(URI.parse(url)).binmode.read
    perform
  rescue OpenURI::HTTPError => e
    response = e.io
    msg = "Erreur lors de la récupération du document : status #{response.status[0]} with body '#{response.string}'"
    error_message(:http_error, msg)
  rescue Net::OpenTimeout, Net::ReadTimeout, EOFError
    error_message(:timeout_error, 'Temps d\'attente de téléchargement du document écoulé')
  rescue URI::InvalidURIError => e
    error_message(:invalid_url, 'L\'URL vers le document renvoyée par le fournisseur de données est invalide')
  rescue IOError
    error_message(:http_error, 'Erreur de lecture sur le server distant')
  rescue Errno::ECONNRESET
    error_message(:http_error, 'Erreur de connexion sur le server distant')
  rescue OpenSSL::SSL::SSLError => e
    log_warning('SelfHostedDocument: OpenSSL Error while opening URI', e, url)

    @binary = URI.open(URI.parse(url), { ssl_verify_mode: OpenSSL::SSL::VERIFY_NONE }).binmode.read
    perform
  rescue StandardError => e
    raise e
  end
  # rubocop:enable Metrics/AbcSize, Metrics/MethodLength

  def success?
    @errors.empty?
  end

  def url
    @document.url
  end

  private

  def perform
    if valid_format?
      @document = @doc_uploader.call(filename, @binary)
    else
      error_message(:invalid_extension, "Le fichier n'est pas au format `#{file_extension}` attendu.")
    end
    self
  end

  def valid_format?
    doc_validator.valid?(@binary)
  end

  def file_extension
    raise 'should be overriden in inherited classes'
  end

  def filename
    "#{file_label}.#{file_extension}"
  end

  def doc_validator
    @doc_validator ||= SIADE::SelfHostedDocument::FormatValidator.new(file_extension)
  end

  def error_message(kind, msg)
    @errors << [kind, msg]
    self
  end

  def log_error(message, exception, url)
    log_event(
      'error',
      message,
      {
        exception: exception.message,
        url: url,
        host: URI(url).host
      }
    )
  end

  def log_warning(message, exception, url)
    log_event(
      'warning',
      message,
      {
        exception: exception.message,
        url: url
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
