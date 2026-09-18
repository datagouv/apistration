# frozen_string_literal: true
# DO NOT EDIT — generated from commons/swagger/openapi-*.yaml by
# clients/ruby/bin/scaffold_resources. Edit the OpenAPI spec or the scaffold
# script instead.

module ApiEntreprise
  module Resources
    class Token
      def initialize(client)
        @client = client
      end

      # Introspection du jeton
      # Logical endpoint: /token/introspect
      # Versions available: [3] — default: 3
      def introspect(version: nil, recipient: nil, delegation_id: nil)
        path =
          case version || 3
          when 3
          "/v3/token/introspect"
          else
            raise ArgumentError, "version #{version.inspect} not available for /token/introspect; supported: [3]"
          end
        @client.get(path, params: { "recipient" => recipient, "delegation_id" => delegation_id }.compact)
      end
    end
  end
end
