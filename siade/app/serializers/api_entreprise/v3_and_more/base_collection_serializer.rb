class APIEntreprise::V3AndMore::BaseCollectionSerializer < BaseCollectionSerializer
  class << self
    def url_domain
      'entreprise.api.gouv.fr'
    end

    def url_for_proxied_file(url)
      url_for(
        controller: 'api_entreprise/proxied_files',
        action: :show,
        uuid: ProxiedFileService.set(url)
      )
    rescue ProxiedFileService::ConnectionError
      url
    end
  end
end
