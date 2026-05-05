# frozen_string_literal: true
# DO NOT EDIT — generated from commons/swagger/openapi-*.yaml by
# clients/ruby/bin/scaffold_resources. Edit the OpenAPI spec or the scaffold
# script instead.

module ApiEntreprise
  module Resources
    class EuropeanCommission
      def initialize(client)
        @client = client
      end

      # N°TVA intracommunautaire français
      # Logical endpoint: /european_commission/unites_legales/{siren}/numero_tva
      # Versions available: [3] — default: 3
      def numero_tva(siren, version: nil, recipient: nil, context: nil, object: nil)
        Commons::Siren.validate!(siren, parameter: :siren)
        path =
          case version || 3
          when 3
          "/v3/european_commission/unites_legales/#{siren}/numero_tva"
          else
            raise ArgumentError, "version #{version.inspect} not available for /european_commission/unites_legales/{siren}/numero_tva; supported: [3]"
          end
        @client.get(path, params: { "recipient" => recipient, "context" => context, "object" => object }.compact)
      end
    end
  end
end
