# frozen_string_literal: true
# DO NOT EDIT — generated from commons/swagger/openapi-*.yaml by
# clients/ruby/bin/scaffold_resources. Edit the OpenAPI spec or the scaffold
# script instead.

module ApiEntreprise
  module Resources
    class Probtp
      def initialize(client)
        @client = client
      end

      # Conformité cotisations retraite bâtiment
      # Logical endpoint: /probtp/etablissements/{siret}/attestation_cotisations_retraite
      # Versions available: [3] — default: 3
      def attestation_cotisations_retraite(siret, version: nil)
        Commons::Siret.validate!(siret, parameter: :siret)
        path =
          case version || 3
          when 3
          "/v3/probtp/etablissements/#{siret}/attestation_cotisations_retraite"
          else
            raise ArgumentError, "version #{version.inspect} not available for /probtp/etablissements/{siret}/attestation_cotisations_retraite; supported: [3]"
          end
        @client.get(path, params: {})
      end

      # Conformité cotisations retraite complémentaire
      # Logical endpoint: /probtp/etablissements/{siret}/conformite_cotisations_retraite
      # Versions available: [3] — default: 3
      def conformite_cotisations_retraite(siret, version: nil)
        Commons::Siret.validate!(siret, parameter: :siret)
        path =
          case version || 3
          when 3
          "/v3/probtp/etablissements/#{siret}/conformite_cotisations_retraite"
          else
            raise ArgumentError, "version #{version.inspect} not available for /probtp/etablissements/{siret}/conformite_cotisations_retraite; supported: [3]"
          end
        @client.get(path, params: {})
      end
    end
  end
end
