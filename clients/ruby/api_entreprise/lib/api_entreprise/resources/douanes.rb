# frozen_string_literal: true
# DO NOT EDIT — generated from commons/swagger/openapi-*.yaml by
# clients/ruby/bin/scaffold_resources. Edit the OpenAPI spec or the scaffold
# script instead.

module ApiEntreprise
  module Resources
    class Douanes
      def initialize(client)
        @client = client
      end

      # Immatriculation EORI
      # Logical endpoint: /douanes/etablissements/{siret_or_eori}/immatriculations_eori
      # Versions available: [3] — default: 3
      def immatriculations_eori(siret_or_eori, version: nil)
        path =
          case version || 3
          when 3
          "/v3/douanes/etablissements/#{siret_or_eori}/immatriculations_eori"
          else
            raise ArgumentError, "version #{version.inspect} not available for /douanes/etablissements/{siret_or_eori}/immatriculations_eori; supported: [3]"
          end
        @client.get(path, params: {})
      end
    end
  end
end
