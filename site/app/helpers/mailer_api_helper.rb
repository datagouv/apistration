module MailerAPIHelper
  API_SPECIFICS = {
    'entreprise' => {
      logo_alt: 'API Entreprise, les données entreprises et associations pour les administrations',
      faq_informations_anchor: 'api_entreprise_faq_entry_quelles-informations-me-seront-demandees',
      datapass_new_authorization_request_url: 'https://datapass.api.gouv.fr/demandes/api-entreprise/nouveau'
    },
    'particulier' => {
      logo_alt: 'API Particulier, les données des particuliers pour les administrations',
      faq_informations_anchor: 'quelles-informations-me-seront-demandees',
      datapass_new_authorization_request_url: 'https://datapass.api.gouv.fr/api-particulier'
    }
  }.freeze

  def api_url(route, **)
    public_send("#{api_route_prefix}#{route}_url", **)
  end

  def api_root_url
    namespace == 'entreprise' ? root_url : api_particulier_url
  end

  def api_support_email
    "support@#{namespace}.api.gouv.fr"
  end

  def api_status_host
    "status.#{namespace}.api.gouv.fr"
  end

  def api_specific(key)
    API_SPECIFICS.fetch(namespace).fetch(key)
  end

  private

  def api_route_prefix
    namespace == 'entreprise' ? '' : 'api_particulier_'
  end
end
