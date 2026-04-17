# frozen_string_literal: true
# DO NOT EDIT — generated from commons/swagger/openapi-*.yaml by
# clients/ruby/bin/scaffold_resources. Edit the OpenAPI spec or the scaffold
# script instead.

module ApiParticulier
  module Resources
    class Ants
      def initialize(client)
        @client = client
      end

      # [FranceConnect] Extrait d'immatriculation véhicule
      # Logical endpoint: /ants/extrait_immatriculation_vehicule/france_connect
      # Versions available: [3] — default: 3
      def extrait_immatriculation_vehicule(version: nil, immatriculation: nil)
        path =
          case version || 3
          when 3
          "/v3/ants/extrait_immatriculation_vehicule/france_connect"
          else
            raise ArgumentError, "version #{version.inspect} not available for /ants/extrait_immatriculation_vehicule/france_connect; supported: [3]"
          end
        @client.get(path, params: { "immatriculation" => immatriculation }.compact)
      end
    end
  end
end
