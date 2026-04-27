# frozen_string_literal: true
# DO NOT EDIT — generated from commons/swagger/openapi-*.yaml by
# clients/ruby/bin/scaffold_resources. Edit the OpenAPI spec or the scaffold
# script instead.

module ApiEntreprise
  module Resources
    class Cibtp
      def initialize(client)
        @client = client
      end

      # Certificat cotisations CIBTP
      # Logical endpoint: /cibtp/etablissements/{siret}/attestation_cotisations_conges_payes_chomage_intemperies
      # Versions available: [3] — default: 3
      def attestation_cotisations_conges_payes_chomage_intemperies(siret, version: nil, recipient: nil, context: nil, object: nil)
        Commons::Siret.validate!(siret, parameter: :siret)
        path =
          case version || 3
          when 3
          "/v3/cibtp/etablissements/#{siret}/attestation_cotisations_conges_payes_chomage_intemperies"
          else
            raise ArgumentError, "version #{version.inspect} not available for /cibtp/etablissements/{siret}/attestation_cotisations_conges_payes_chomage_intemperies; supported: [3]"
          end
        @client.get(path, params: { "recipient" => recipient, "context" => context, "object" => object }.compact)
      end
    end
  end
end
