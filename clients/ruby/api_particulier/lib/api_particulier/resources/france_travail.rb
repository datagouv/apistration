# frozen_string_literal: true
# DO NOT EDIT — generated from commons/swagger/openapi-*.yaml by
# clients/ruby/bin/scaffold_resources. Edit the OpenAPI spec or the scaffold
# script instead.

module ApiParticulier
  module Resources
    class FranceTravail
      def initialize(client)
        @client = client
      end

      # Paiements versés par France Travail
      # Logical endpoint: /france_travail/indemnites/identifiant
      # Versions available: [3] — default: 3
      def indemnites(version: nil, recipient: nil, identifiant:)
        path =
          case version || 3
          when 3
          "/v3/france_travail/indemnites/identifiant"
          else
            raise ArgumentError, "version #{version.inspect} not available for /france_travail/indemnites/identifiant; supported: [3]"
          end
        @client.get(path, params: { "recipient" => recipient, "identifiant" => identifiant }.compact)
      end

      # Statut demandeur d'emploi
      # Logical endpoint: /france_travail/statut/identifiant
      # Versions available: [3] — default: 3
      def statut(version: nil, recipient: nil, identifiant:)
        path =
          case version || 3
          when 3
          "/v3/france_travail/statut/identifiant"
          else
            raise ArgumentError, "version #{version.inspect} not available for /france_travail/statut/identifiant; supported: [3]"
          end
        @client.get(path, params: { "recipient" => recipient, "identifiant" => identifiant }.compact)
      end
    end
  end
end
