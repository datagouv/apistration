class Documents::RetrieveFromUrl < ApplicationInteractor
  before do
    context.errors ||= []
  end

  def call
    context.content = URI.open(source_url).binmode.read
  rescue OpenURI::HTTPError => e
    response = e.io
    msg = "Erreur lors de la récupération du document : status #{response.status[0]} with body '#{response.string}'"
    fail_with_error(:http_error, msg)
  rescue Net::OpenTimeout, Net::ReadTimeout
    fail_with_error(:timeout_error, 'Temps d\'attente de téléchargement du document écoulé')
  rescue URI::InvalidURIError => e
    msg = "L\'URL source du document chez le fournisseur de données est invalide : #{e.message}."
    fail_with_error(:invalid_url, msg)
  end

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
end
