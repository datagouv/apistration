# frozen_string_literal: true
# DO NOT EDIT — generated from commons/swagger/openapi-*.yaml by
# clients/ruby/bin/scaffold_resources. Edit the OpenAPI spec or the scaffold
# script instead.

module ApiEntreprise
  module Resources
    class Fntp
      def initialize(client)
        @client = client
      end

      # Carte professionnelle travaux publics
      # Logical endpoint: /fntp/unites_legales/{siren}/carte_professionnelle_travaux_publics
      # Versions available: [3] — default: 3
      def carte_professionnelle_travaux_publics(siren, version: nil)
        Commons::Siren.validate!(siren, parameter: :siren)
        path =
          case version || 3
          when 3
          "/v3/fntp/unites_legales/#{siren}/carte_professionnelle_travaux_publics"
          else
            raise ArgumentError, "version #{version.inspect} not available for /fntp/unites_legales/{siren}/carte_professionnelle_travaux_publics; supported: [3]"
          end
        @client.get(path, params: {})
      end
    end
  end
end
