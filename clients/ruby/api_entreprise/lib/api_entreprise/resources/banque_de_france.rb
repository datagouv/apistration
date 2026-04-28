# frozen_string_literal: true
# DO NOT EDIT — generated from commons/swagger/openapi-*.yaml by
# clients/ruby/bin/scaffold_resources. Edit the OpenAPI spec or the scaffold
# script instead.

module ApiEntreprise
  module Resources
    class BanqueDeFrance
      def initialize(client)
        @client = client
      end

      # 3 derniers bilans annuels
      # Logical endpoint: /banque_de_france/unites_legales/{siren}/bilans
      # Versions available: [3] — default: 3
      def bilans(siren, version: nil, recipient: nil, context: nil, object: nil)
        Commons::Siren.validate!(siren, parameter: :siren)
        path =
          case version || 3
          when 3
          "/v3/banque_de_france/unites_legales/#{siren}/bilans"
          else
            raise ArgumentError, "version #{version.inspect} not available for /banque_de_france/unites_legales/{siren}/bilans; supported: [3]"
          end
        @client.get(path, params: { "recipient" => recipient, "context" => context, "object" => object }.compact)
      end
    end
  end
end
