# frozen_string_literal: true
# DO NOT EDIT — generated from commons/swagger/openapi-*.yaml by
# clients/ruby/bin/scaffold_resources. Edit the OpenAPI spec or the scaffold
# script instead.

module ApiEntreprise
  module Resources
    class Cnetp
      def initialize(client)
        @client = client
      end

      # Certificat cotisations CNETP
      # Logical endpoint: /cnetp/unites_legales/{siren}/attestation_cotisations_conges_payes_chomage_intemperies
      # Versions available: [3] — default: 3
      def attestation_cotisations_conges_payes_chomage_intemperies(siren, version: nil, recipient: nil, context: nil, object: nil)
        Commons::Siren.validate!(siren, parameter: :siren)
        path =
          case version || 3
          when 3
          "/v3/cnetp/unites_legales/#{siren}/attestation_cotisations_conges_payes_chomage_intemperies"
          else
            raise ArgumentError, "version #{version.inspect} not available for /cnetp/unites_legales/{siren}/attestation_cotisations_conges_payes_chomage_intemperies; supported: [3]"
          end
        @client.get(path, params: { "recipient" => recipient, "context" => context, "object" => object }.compact)
      end
    end
  end
end
