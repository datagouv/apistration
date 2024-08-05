class APIEntreprise::V3AndMore::BaseSerializer < BaseSerializer
  protected

  def url_for_proxied_file(url)
    url_for(
      controller: 'api_entreprise/proxied_files',
      action: :show,
      uuid: ProxiedFileService.set(url)
    )
  rescue ProxiedFileService::ConnectionError
    url
  end

  def url_for(params = {})
    host = Rails.env.production? ? url_domain : "#{Rails.env}.#{url_domain}"

    Rails.application.routes.url_helpers.url_for(params.merge(host:))
  end

  def url_domain
    'entreprise.api.gouv.fr'
  end
end
