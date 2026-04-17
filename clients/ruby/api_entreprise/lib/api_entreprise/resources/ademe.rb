# frozen_string_literal: true
# DO NOT EDIT — generated from commons/swagger/openapi-*.yaml by
# clients/ruby/bin/scaffold_resources. Edit the OpenAPI spec or the scaffold
# script instead.

module ApiEntreprise
  module Resources
    class Ademe
      def initialize(client)
        @client = client
      end

      # Certification RGE
      # Logical endpoint: /ademe/etablissements/{siret}/certification_rge
      # Versions available: [3] — default: 3
      def certification_rge(siret, version: nil, limit: nil)
        Commons::Siret.validate!(siret, parameter: :siret)
        path =
          case version || 3
          when 3
          "/v3/ademe/etablissements/#{siret}/certification_rge"
          else
            raise ArgumentError, "version #{version.inspect} not available for /ademe/etablissements/{siret}/certification_rge; supported: [3]"
          end
        @client.get(path, params: { "limit" => limit }.compact)
      end
    end
  end
end
