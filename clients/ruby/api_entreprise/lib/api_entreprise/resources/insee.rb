# frozen_string_literal: true
# DO NOT EDIT — generated from commons/swagger/openapi-*.yaml by
# clients/ruby/bin/scaffold_resources. Edit the OpenAPI spec or the scaffold
# script instead.

module ApiEntreprise
  module Resources
    class Insee
      def initialize(client)
        @client = client
      end

      # Données établissement en open data
      # Logical endpoint: /insee/sirene/etablissements/diffusibles/{siret}
      # Versions available: [3, 4] — default: 4
      def diffusibles(siret, version: nil)
        Commons::Siret.validate!(siret, parameter: :siret)
        path =
          case version || 4
          when 3
          warn "[DEPRECATED] /v3/insee/sirene/etablissements/diffusibles/{siret} (#diffusibles): marked deprecated in the OpenAPI spec.", uplevel: 1
          "/v3/insee/sirene/etablissements/diffusibles/#{siret}"
          when 4
          "/v4/insee/sirene/etablissements/diffusibles/#{siret}"
          else
            raise ArgumentError, "version #{version.inspect} not available for /insee/sirene/etablissements/diffusibles/{siret}; supported: [3, 4]"
          end
        @client.get(path, params: {})
      end

      # Adresse établissement en open data
      # Logical endpoint: /insee/sirene/etablissements/diffusibles/{siret}/adresse
      # Versions available: [3] — default: 3
      def adresse(siret, version: nil)
        Commons::Siret.validate!(siret, parameter: :siret)
        path =
          case version || 3
          when 3
          "/v3/insee/sirene/etablissements/diffusibles/#{siret}/adresse"
          else
            raise ArgumentError, "version #{version.inspect} not available for /insee/sirene/etablissements/diffusibles/{siret}/adresse; supported: [3]"
          end
        @client.get(path, params: {})
      end

      # Données établissement
      # Logical endpoint: /insee/sirene/etablissements/{siret}
      # Versions available: [3, 4] — default: 4
      def etablissements(siret, version: nil)
        Commons::Siret.validate!(siret, parameter: :siret)
        path =
          case version || 4
          when 3
          warn "[DEPRECATED] /v3/insee/sirene/etablissements/{siret} (#etablissements): marked deprecated in the OpenAPI spec.", uplevel: 1
          "/v3/insee/sirene/etablissements/#{siret}"
          when 4
          "/v4/insee/sirene/etablissements/#{siret}"
          else
            raise ArgumentError, "version #{version.inspect} not available for /insee/sirene/etablissements/{siret}; supported: [3, 4]"
          end
        @client.get(path, params: {})
      end

      # Adresse établissement
      # Logical endpoint: /insee/sirene/etablissements/{siret}/adresse
      # Versions available: [3] — default: 3
      def sirene_etablissements_adresse(siret, version: nil)
        Commons::Siret.validate!(siret, parameter: :siret)
        path =
          case version || 3
          when 3
          "/v3/insee/sirene/etablissements/#{siret}/adresse"
          else
            raise ArgumentError, "version #{version.inspect} not available for /insee/sirene/etablissements/{siret}/adresse; supported: [3]"
          end
        @client.get(path, params: {})
      end

      # Liens de succession
      # Logical endpoint: /insee/sirene/etablissements/{siret}/successions
      # Versions available: [3] — default: 3
      def successions(siret, version: nil)
        Commons::Siret.validate!(siret, parameter: :siret)
        path =
          case version || 3
          when 3
          "/v3/insee/sirene/etablissements/#{siret}/successions"
          else
            raise ArgumentError, "version #{version.inspect} not available for /insee/sirene/etablissements/{siret}/successions; supported: [3]"
          end
        @client.get(path, params: {})
      end

      # Données unité légale en open data
      # Logical endpoint: /insee/sirene/unites_legales/diffusibles/{siren}
      # Versions available: [3, 4] — default: 4
      def sirene_unites_legales_diffusibles(siren, version: nil)
        Commons::Siren.validate!(siren, parameter: :siren)
        path =
          case version || 4
          when 3
          warn "[DEPRECATED] /v3/insee/sirene/unites_legales/diffusibles/{siren} (#sirene_unites_legales_diffusibles): marked deprecated in the OpenAPI spec.", uplevel: 1
          "/v3/insee/sirene/unites_legales/diffusibles/#{siren}"
          when 4
          "/v4/insee/sirene/unites_legales/diffusibles/#{siren}"
          else
            raise ArgumentError, "version #{version.inspect} not available for /insee/sirene/unites_legales/diffusibles/{siren}; supported: [3, 4]"
          end
        @client.get(path, params: {})
      end

      # Données siège social en open data
      # Logical endpoint: /insee/sirene/unites_legales/diffusibles/{siren}/siege_social
      # Versions available: [3, 4] — default: 4
      def siege_social(siren, version: nil)
        Commons::Siren.validate!(siren, parameter: :siren)
        path =
          case version || 4
          when 3
          warn "[DEPRECATED] /v3/insee/sirene/unites_legales/diffusibles/{siren}/siege_social (#siege_social): marked deprecated in the OpenAPI spec.", uplevel: 1
          "/v3/insee/sirene/unites_legales/diffusibles/#{siren}/siege_social"
          when 4
          "/v4/insee/sirene/unites_legales/diffusibles/#{siren}/siege_social"
          else
            raise ArgumentError, "version #{version.inspect} not available for /insee/sirene/unites_legales/diffusibles/{siren}/siege_social; supported: [3, 4]"
          end
        @client.get(path, params: {})
      end

      # Données unité légale
      # Logical endpoint: /insee/sirene/unites_legales/{siren}
      # Versions available: [3, 4] — default: 4
      def unites_legales(siren, version: nil)
        Commons::Siren.validate!(siren, parameter: :siren)
        path =
          case version || 4
          when 3
          warn "[DEPRECATED] /v3/insee/sirene/unites_legales/{siren} (#unites_legales): marked deprecated in the OpenAPI spec.", uplevel: 1
          "/v3/insee/sirene/unites_legales/#{siren}"
          when 4
          "/v4/insee/sirene/unites_legales/#{siren}"
          else
            raise ArgumentError, "version #{version.inspect} not available for /insee/sirene/unites_legales/{siren}; supported: [3, 4]"
          end
        @client.get(path, params: {})
      end

      # Données siège social
      # Logical endpoint: /insee/sirene/unites_legales/{siren}/siege_social
      # Versions available: [3, 4] — default: 4
      def sirene_unites_legales_siege_social(siren, version: nil)
        Commons::Siren.validate!(siren, parameter: :siren)
        path =
          case version || 4
          when 3
          warn "[DEPRECATED] /v3/insee/sirene/unites_legales/{siren}/siege_social (#sirene_unites_legales_siege_social): marked deprecated in the OpenAPI spec.", uplevel: 1
          "/v3/insee/sirene/unites_legales/#{siren}/siege_social"
          when 4
          "/v4/insee/sirene/unites_legales/#{siren}/siege_social"
          else
            raise ArgumentError, "version #{version.inspect} not available for /insee/sirene/unites_legales/{siren}/siege_social; supported: [3, 4]"
          end
        @client.get(path, params: {})
      end
    end
  end
end
