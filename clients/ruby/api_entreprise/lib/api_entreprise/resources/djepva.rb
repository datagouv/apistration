# frozen_string_literal: true
# DO NOT EDIT — generated from commons/swagger/openapi-*.yaml by
# clients/ruby/bin/scaffold_resources. Edit the OpenAPI spec or the scaffold
# script instead.

module ApiEntreprise
  module Resources
    class Djepva
      def initialize(client)
        @client = client
      end

      # Données association en open data
      # Logical endpoint: /djepva/api-association/associations/open_data/{siren_or_rna}
      # Versions available: [4] — default: 4
      def open_data(siren_or_rna, version: nil, recipient: nil, context: nil, object: nil)
        path =
          case version || 4
          when 4
          "/v4/djepva/api-association/associations/open_data/#{siren_or_rna}"
          else
            raise ArgumentError, "version #{version.inspect} not available for /djepva/api-association/associations/open_data/{siren_or_rna}; supported: [4]"
          end
        @client.get(path, params: { "recipient" => recipient, "context" => context, "object" => object }.compact)
      end

      # Données association
      # Logical endpoint: /djepva/api-association/associations/{siren_or_rna}
      # Versions available: [4] — default: 4
      def associations(siren_or_rna, version: nil, recipient: nil, context: nil, object: nil)
        path =
          case version || 4
          when 4
          "/v4/djepva/api-association/associations/#{siren_or_rna}"
          else
            raise ArgumentError, "version #{version.inspect} not available for /djepva/api-association/associations/{siren_or_rna}; supported: [4]"
          end
        @client.get(path, params: { "recipient" => recipient, "context" => context, "object" => object }.compact)
      end
    end
  end
end
