# frozen_string_literal: true
# DO NOT EDIT — generated from commons/swagger/openapi-*.yaml by
# clients/ruby/bin/scaffold_resources. Edit the OpenAPI spec or the scaffold
# script instead.

module ApiEntreprise
  module Resources
    class FabriqueNumeriqueMinisteresSociaux
      def initialize(client)
        @client = client
      end

      # Conventions collectives
      # Logical endpoint: /fabrique_numerique_ministeres_sociaux/etablissements/{siret}/conventions_collectives
      # Versions available: [3] — default: 3 (deprecated)
      def conventions_collectives(siret, version: nil)
        Commons::Siret.validate!(siret, parameter: :siret)
        path =
          case version || 3
          when 3
          warn "[DEPRECATED] /v3/fabrique_numerique_ministeres_sociaux/etablissements/{siret}/conventions_collectives (#conventions_collectives): marked deprecated in the OpenAPI spec.", uplevel: 1
          "/v3/fabrique_numerique_ministeres_sociaux/etablissements/#{siret}/conventions_collectives"
          else
            raise ArgumentError, "version #{version.inspect} not available for /fabrique_numerique_ministeres_sociaux/etablissements/{siret}/conventions_collectives; supported: [3]"
          end
        @client.get(path, params: {})
      end
    end
  end
end
