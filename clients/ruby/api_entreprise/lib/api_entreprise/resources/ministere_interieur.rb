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
      def associations(siret_or_rna, version: nil, recipient: nil, delegation_id: nil, context: nil, object: nil)
        path =
          case version || 3
          when 3
          warn "[DEPRECATED] /v3/ministere_interieur/rna/associations/{siret_or_rna} (#associations): marked deprecated in the OpenAPI spec.", uplevel: 1
          "/v3/ministere_interieur/rna/associations/#{siret_or_rna}"
          else
            raise ArgumentError, "version #{version.inspect} not available for /ministere_interieur/rna/associations/{siret_or_rna}; supported: [3]"
          end
        @client.get(path, params: { "recipient" => recipient, "delegation_id" => delegation_id, "context" => context, "object" => object }.compact)
      end

      # Divers documents d'une association
      # Logical endpoint: /ministere_interieur/rna/associations/{siret_or_rna}/documents
      # Versions available: [3] — default: 3 (deprecated)
      def documents(siret_or_rna, version: nil, recipient: nil, delegation_id: nil, context: nil, object: nil)
        path =
          case version || 3
          when 3
          warn "[DEPRECATED] /v3/ministere_interieur/rna/associations/{siret_or_rna}/documents (#documents): marked deprecated in the OpenAPI spec.", uplevel: 1
          "/v3/ministere_interieur/rna/associations/#{siret_or_rna}/documents"
          else
            raise ArgumentError, "version #{version.inspect} not available for /ministere_interieur/rna/associations/{siret_or_rna}/documents; supported: [3]"
          end
        @client.get(path, params: { "recipient" => recipient, "delegation_id" => delegation_id, "context" => context, "object" => object }.compact)
      end

      # Données associations en open data
      # Logical endpoint: /ministere_interieur/siaf/associations/open_data/{siren_or_siret_or_rna}
      # Versions available: [3] — default: 3
      def open_data(siren_or_siret_or_rna, version: nil, recipient: nil, delegation_id: nil, context: nil, object: nil)
        path =
          case version || 3
          when 3
          "/v3/ministere_interieur/siaf/associations/open_data/#{siren_or_siret_or_rna}"
          else
            raise ArgumentError, "version #{version.inspect} not available for /ministere_interieur/siaf/associations/open_data/{siren_or_siret_or_rna}; supported: [3]"
          end
        @client.get(path, params: { "recipient" => recipient, "delegation_id" => delegation_id, "context" => context, "object" => object }.compact)
      end

      # Données associations
      # Logical endpoint: /ministere_interieur/siaf/associations/{siren_or_siret_or_rna}
      # Versions available: [3] — default: 3
      def siaf_associations(siren_or_siret_or_rna, version: nil, recipient: nil, delegation_id: nil, context: nil, object: nil)
        path =
          case version || 3
          when 3
          "/v3/ministere_interieur/siaf/associations/#{siren_or_siret_or_rna}"
          else
            raise ArgumentError, "version #{version.inspect} not available for /ministere_interieur/siaf/associations/{siren_or_siret_or_rna}; supported: [3]"
          end
        @client.get(path, params: { "recipient" => recipient, "delegation_id" => delegation_id, "context" => context, "object" => object }.compact)
      end

      # Données fondations
      # Logical endpoint: /ministere_interieur/siaf/fondations/{siren_or_siret_or_rnf}
      # Versions available: [3] — default: 3
      def fondations(siren_or_siret_or_rnf, version: nil, recipient: nil, delegation_id: nil, context: nil, object: nil)
        path =
          case version || 3
          when 3
          "/v3/ministere_interieur/siaf/fondations/#{siren_or_siret_or_rnf}"
          else
            raise ArgumentError, "version #{version.inspect} not available for /ministere_interieur/siaf/fondations/{siren_or_siret_or_rnf}; supported: [3]"
          end
        @client.get(path, params: { "recipient" => recipient, "delegation_id" => delegation_id, "context" => context, "object" => object }.compact)
      end
    end
  end
end
