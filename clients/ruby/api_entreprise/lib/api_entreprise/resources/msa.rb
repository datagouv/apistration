# frozen_string_literal: true
# DO NOT EDIT — generated from commons/swagger/openapi-*.yaml by
# clients/ruby/bin/scaffold_resources. Edit the OpenAPI spec or the scaffold
# script instead.

module ApiEntreprise
  module Resources
    class Msa
      def initialize(client)
        @client = client
      end

      # Conformité cotisations de sécurité sociale agricole
      # Logical endpoint: /msa/etablissements/{siret}/conformite_cotisations
      # Versions available: [3] — default: 3
      def conformite_cotisations(siret, version: nil)
        Commons::Siret.validate!(siret, parameter: :siret)
        path =
          case version || 3
          when 3
          "/v3/msa/etablissements/#{siret}/conformite_cotisations"
          else
            raise ArgumentError, "version #{version.inspect} not available for /msa/etablissements/{siret}/conformite_cotisations; supported: [3]"
          end
        @client.get(path, params: {})
      end
    end
  end
end
