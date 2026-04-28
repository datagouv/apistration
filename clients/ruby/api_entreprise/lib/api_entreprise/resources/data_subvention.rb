# frozen_string_literal: true
# DO NOT EDIT — generated from commons/swagger/openapi-*.yaml by
# clients/ruby/bin/scaffold_resources. Edit the OpenAPI spec or the scaffold
# script instead.

module ApiEntreprise
  module Resources
    class DataSubvention
      def initialize(client)
        @client = client
      end

      # Subventions des associations
      # Logical endpoint: /data_subvention/associations/{siren_or_siret_or_rna}/subventions
      # Versions available: [3] — default: 3
      def subventions(siren_or_siret_or_rna, version: nil, recipient: nil, context: nil, object: nil)
        path =
          case version || 3
          when 3
          "/v3/data_subvention/associations/#{siren_or_siret_or_rna}/subventions"
          else
            raise ArgumentError, "version #{version.inspect} not available for /data_subvention/associations/{siren_or_siret_or_rna}/subventions; supported: [3]"
          end
        @client.get(path, params: { "recipient" => recipient, "context" => context, "object" => object }.compact)
      end
    end
  end
end
