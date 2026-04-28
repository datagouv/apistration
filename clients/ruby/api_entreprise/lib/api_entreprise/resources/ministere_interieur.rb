# frozen_string_literal: true
# DO NOT EDIT — generated from commons/swagger/openapi-*.yaml by
# clients/ruby/bin/scaffold_resources. Edit the OpenAPI spec or the scaffold
# script instead.

module ApiEntreprise
  module Resources
    class MinistereInterieur
      def initialize(client)
        @client = client
      end

      # Données du RNA d'une association
      # Logical endpoint: /ministere_interieur/rna/associations/{siret_or_rna}
      # Versions available: [3] — default: 3 (deprecated)
      def associations(siret_or_rna, version: nil, recipient: nil, context: nil, object: nil)
        path =
          case version || 3
          when 3
          warn "[DEPRECATED] /v3/ministere_interieur/rna/associations/{siret_or_rna} (#associations): marked deprecated in the OpenAPI spec.", uplevel: 1
          "/v3/ministere_interieur/rna/associations/#{siret_or_rna}"
          else
            raise ArgumentError, "version #{version.inspect} not available for /ministere_interieur/rna/associations/{siret_or_rna}; supported: [3]"
          end
        @client.get(path, params: { "recipient" => recipient, "context" => context, "object" => object }.compact)
      end

      # Divers documents d'une association
      # Logical endpoint: /ministere_interieur/rna/associations/{siret_or_rna}/documents
      # Versions available: [3] — default: 3 (deprecated)
      def documents(siret_or_rna, version: nil, recipient: nil, context: nil, object: nil)
        path =
          case version || 3
          when 3
          warn "[DEPRECATED] /v3/ministere_interieur/rna/associations/{siret_or_rna}/documents (#documents): marked deprecated in the OpenAPI spec.", uplevel: 1
          "/v3/ministere_interieur/rna/associations/#{siret_or_rna}/documents"
          else
            raise ArgumentError, "version #{version.inspect} not available for /ministere_interieur/rna/associations/{siret_or_rna}/documents; supported: [3]"
          end
        @client.get(path, params: { "recipient" => recipient, "context" => context, "object" => object }.compact)
      end
    end
  end
end
