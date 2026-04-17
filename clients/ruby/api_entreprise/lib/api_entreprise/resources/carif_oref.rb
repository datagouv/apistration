# frozen_string_literal: true
# DO NOT EDIT — generated from commons/swagger/openapi-*.yaml by
# clients/ruby/bin/scaffold_resources. Edit the OpenAPI spec or the scaffold
# script instead.

module ApiEntreprise
  module Resources
    class CarifOref
      def initialize(client)
        @client = client
      end

      # Qualiopi & habilitations France compétences
      # Logical endpoint: /carif_oref/etablissements/{siret}/certifications_qualiopi_france_competences
      # Versions available: [3] — default: 3
      def certifications_qualiopi_france_competences(siret, version: nil)
        Commons::Siret.validate!(siret, parameter: :siret)
        path =
          case version || 3
          when 3
          "/v3/carif_oref/etablissements/#{siret}/certifications_qualiopi_france_competences"
          else
            raise ArgumentError, "version #{version.inspect} not available for /carif_oref/etablissements/{siret}/certifications_qualiopi_france_competences; supported: [3]"
          end
        @client.get(path, params: {})
      end
    end
  end
end
