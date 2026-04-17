# frozen_string_literal: true
# DO NOT EDIT — generated from commons/swagger/openapi-*.yaml by
# clients/ruby/bin/scaffold_resources. Edit the OpenAPI spec or the scaffold
# script instead.

module ApiEntreprise
  module Resources
    class CmaFrance
      def initialize(client)
        @client = client
      end

      # Données du RNM d'une entreprise artisanale
      # Logical endpoint: /cma_france/rnm/unites_legales/{siren}
      # Versions available: [3] — default: 3 (deprecated)
      def unites_legales(siren, version: nil)
        Commons::Siren.validate!(siren, parameter: :siren)
        path =
          case version || 3
          when 3
          warn "[DEPRECATED] /v3/cma_france/rnm/unites_legales/{siren} (#unites_legales): marked deprecated in the OpenAPI spec.", uplevel: 1
          "/v3/cma_france/rnm/unites_legales/#{siren}"
          else
            raise ArgumentError, "version #{version.inspect} not available for /cma_france/rnm/unites_legales/{siren}; supported: [3]"
          end
        @client.get(path, params: {})
      end
    end
  end
end
