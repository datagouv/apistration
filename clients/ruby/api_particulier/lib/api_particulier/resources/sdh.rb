# frozen_string_literal: true
# DO NOT EDIT — generated from commons/swagger/openapi-*.yaml by
# clients/ruby/bin/scaffold_resources. Edit the OpenAPI spec or the scaffold
# script instead.

module ApiParticulier
  module Resources
    class Sdh
      def initialize(client)
        @client = client
      end

      # [Identifiant] API Statut sportif de haut niveau et sur liste ministérielle
      # Logical endpoint: /sdh/statut_sportif/identifiant
      # Versions available: [3] — default: 3
      def statut_sportif(version: nil, identifiant: nil)
        path =
          case version || 3
          when 3
          "/v3/sdh/statut_sportif/identifiant"
          else
            raise ArgumentError, "version #{version.inspect} not available for /sdh/statut_sportif/identifiant; supported: [3]"
          end
        @client.get(path, params: { "identifiant" => identifiant }.compact)
      end
    end
  end
end
