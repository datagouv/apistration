module Datagouv
  class FichePayloadBuilder
    include Rails.application.routes.url_helpers

    ORGANIZATION_ID = '57fe2a35c751df21e179df72'.freeze

    API_CONFIG = {
      'api_entreprise' => {
        base_api_url: 'https://entreprise.api.gouv.fr',
        business_documentation_url_helper: :endpoint_url,
        technical_documentation_url_helper: :developers_openapi_url,
        machine_documentation_url_helper: :openapi_without_deprecated_definition_url,
        authorization_request_url: 'https://datapass.api.gouv.fr/api-entreprise',
        display_name: 'Entreprise'
      },
      'api_particulier' => {
        base_api_url: 'https://particulier.api.gouv.fr',
        business_documentation_url_helper: :api_particulier_endpoint_url,
        technical_documentation_url_helper: :api_particulier_developers_openapi_url,
        machine_documentation_url_helper: :api_particulier_openapi_definition_url,
        authorization_request_url: 'https://datapass.api.gouv.fr/api-particulier',
        display_name: 'Particulier'
      }
    }.freeze

    BASE_TAGS = {
      'api_entreprise' => %w[api-entreprise administration administration-et-legislation],
      'api_particulier' => %w[api-particulier administration administration-et-legislation]
    }.freeze

    def initialize(endpoint)
      @endpoint = endpoint
    end

    def payload
      base_payload.merge(rate_limiting_payload)
    end

    def creation_payload
      payload.merge(organization: ORGANIZATION_ID)
    end

    def title
      "API #{endpoint.title} - #{provider_name} | Bouquet API #{config[:display_name]}"
    end

    private

    attr_reader :endpoint

    def base_payload
      {
        access_type: access_type,
        base_api_url: config[:base_api_url],
        business_documentation_url: business_documentation_url,
        technical_documentation_url: technical_documentation_url,
        machine_documentation_url: machine_documentation_url,
        authorization_request_url: config[:authorization_request_url],
        title: title,
        description: description,
        tags: tags
      }
    end

    def config
      API_CONFIG.fetch(endpoint.api)
    end

    def url_host
      @url_host ||= URI(config[:base_api_url]).host
    end

    def access_type
      endpoint.opening == 'public' ? 'open' : 'restricted'
    end

    def restricted?
      access_type == 'restricted'
    end

    def business_documentation_url
      public_send(config[:business_documentation_url_helper], uid: endpoint.uid, host: url_host, protocol: 'https')
    end

    def technical_documentation_url
      public_send(config[:technical_documentation_url_helper], anchor: endpoint.redoc_anchor, host: url_host, protocol: 'https')
    end

    def machine_documentation_url
      public_send(config[:machine_documentation_url_helper], host: url_host, protocol: 'https')
    end

    def provider_name
      return nil if endpoint.provider_uids.blank?

      endpoint.providers.first&.name
    end

    def punchline
      endpoint.description.to_s.sub(/\.+\s*\z/, '')
    end

    def call_id_text
      Array(endpoint.call_id).join(' / ')
    end

    def description
      <<~MARKDOWN
        <!-- apistration-endpoint-uid: #{endpoint.uid} -->
        > L'[#{title}](#{business_documentation_url}) permet d'obtenir les informations suivantes : **#{punchline}**.

        ➡️ **Cette API fait partie du bouquet [API #{config[:display_name]}](#{config[:base_api_url]}/catalogue)** opéré par la direction interministérielle du numérique (DINUM). Ces données et l'API source proviennent de #{provider_name}.

        - #{restricted? ? '🔐' : '✅'} **#{restricted? ? 'Uniquement accessible aux administrations et collectivités' : 'Accessible à tous'}**.
        - ☎️ **Modalité d'appel** : #{call_id_text}.
        - 📖 **[Documentation métier](#{business_documentation_url})**
        - 📟 **[Documentation technique (swagger)](#{technical_documentation_url})**
      MARKDOWN
    end

    def tags
      (BASE_TAGS.fetch(endpoint.api) + Array(endpoint.provider_uids) + Array(endpoint.keywords)).map(&:parameterize).uniq.sort
    end

    def rate_limiting_payload
      throttle = endpoint.throttle
      return { rate_limiting: '' } unless throttle

      { rate_limiting: "#{throttle[:limit]} requêtes / #{period_in_words(throttle[:period])}" }
    end

    def period_in_words(period)
      case period
      when 1 then 'seconde'
      when 60 then 'minute'
      else "#{period} secondes"
      end
    end
  end
end
