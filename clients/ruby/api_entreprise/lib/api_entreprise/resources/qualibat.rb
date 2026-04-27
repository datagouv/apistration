# frozen_string_literal: true
# DO NOT EDIT — generated from commons/swagger/openapi-*.yaml by
# clients/ruby/bin/scaffold_resources. Edit the OpenAPI spec or the scaffold
# script instead.

module ApiEntreprise
  module Resources
    class Qualibat
      def initialize(client)
        @client = client
      end

      # Certification Qualibat
      # Logical endpoint: /qualibat/etablissements/{siret}/certification_batiment
      # Versions available: [3, 4] — default: 4
      def certification_batiment(siret, version: nil, recipient: nil, context: nil, object: nil)
        Commons::Siret.validate!(siret, parameter: :siret)
        path =
          case version || 4
          when 3
          warn "[DEPRECATED] /v3/qualibat/etablissements/{siret}/certification_batiment (#certification_batiment): marked deprecated in the OpenAPI spec.", uplevel: 1
          "/v3/qualibat/etablissements/#{siret}/certification_batiment"
          when 4
          "/v4/qualibat/etablissements/#{siret}/certification_batiment"
          else
            raise ArgumentError, "version #{version.inspect} not available for /qualibat/etablissements/{siret}/certification_batiment; supported: [3, 4]"
          end
        @client.get(path, params: { "recipient" => recipient, "context" => context, "object" => object }.compact)
      end
    end
  end
end
