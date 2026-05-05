# frozen_string_literal: true
# DO NOT EDIT — generated from commons/swagger/openapi-*.yaml by
# clients/ruby/bin/scaffold_resources. Edit the OpenAPI spec or the scaffold
# script instead.

module ApiEntreprise
  module Resources
    class Dgfip
      def initialize(client)
        @client = client
      end

      # Chiffre d'affaires
      # Logical endpoint: /dgfip/etablissements/{siret}/chiffres_affaires
      # Versions available: [3] — default: 3
      def chiffres_affaires(siret, version: nil, recipient: nil, context: nil, object: nil)
        Commons::Siret.validate!(siret, parameter: :siret)
        path =
          case version || 3
          when 3
          "/v3/dgfip/etablissements/#{siret}/chiffres_affaires"
          else
            raise ArgumentError, "version #{version.inspect} not available for /dgfip/etablissements/{siret}/chiffres_affaires; supported: [3]"
          end
        @client.get(path, params: { "recipient" => recipient, "context" => context, "object" => object }.compact)
      end

      # Attestation fiscale
      # Logical endpoint: /dgfip/unites_legales/{siren}/attestation_fiscale
      # Versions available: [3, 4] — default: 4
      def attestation_fiscale(siren, version: nil, recipient: nil, context: nil, object: nil)
        Commons::Siren.validate!(siren, parameter: :siren)
        path =
          case version || 4
          when 3
          warn "[DEPRECATED] /v3/dgfip/unites_legales/{siren}/attestation_fiscale (#attestation_fiscale): marked deprecated in the OpenAPI spec.", uplevel: 1
          "/v3/dgfip/unites_legales/#{siren}/attestation_fiscale"
          when 4
          "/v4/dgfip/unites_legales/#{siren}/attestation_fiscale"
          else
            raise ArgumentError, "version #{version.inspect} not available for /dgfip/unites_legales/{siren}/attestation_fiscale; supported: [3, 4]"
          end
        @client.get(path, params: { "recipient" => recipient, "context" => context, "object" => object }.compact)
      end

      # Liasses fiscales
      # Logical endpoint: /dgfip/unites_legales/{siren}/liasses_fiscales/{year}
      # Versions available: [3] — default: 3
      def liasses_fiscales(siren, year, version: nil, recipient: nil, context: nil, object: nil)
        Commons::Siren.validate!(siren, parameter: :siren)
        path =
          case version || 3
          when 3
          "/v3/dgfip/unites_legales/#{siren}/liasses_fiscales/#{year}"
          else
            raise ArgumentError, "version #{version.inspect} not available for /dgfip/unites_legales/{siren}/liasses_fiscales/{year}; supported: [3]"
          end
        @client.get(path, params: { "recipient" => recipient, "context" => context, "object" => object }.compact)
      end

      # Liens capitalistiques
      # Logical endpoint: /dgfip/unites_legales/{siren}/liens_capitalistiques/{year}
      # Versions available: [3] — default: 3
      def liens_capitalistiques(siren, year, version: nil, recipient: nil, context: nil, object: nil)
        Commons::Siren.validate!(siren, parameter: :siren)
        path =
          case version || 3
          when 3
          "/v3/dgfip/unites_legales/#{siren}/liens_capitalistiques/#{year}"
          else
            raise ArgumentError, "version #{version.inspect} not available for /dgfip/unites_legales/{siren}/liens_capitalistiques/{year}; supported: [3]"
          end
        @client.get(path, params: { "recipient" => recipient, "context" => context, "object" => object }.compact)
      end
    end
  end
end
