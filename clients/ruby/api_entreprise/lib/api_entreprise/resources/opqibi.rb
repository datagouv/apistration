# frozen_string_literal: true
# DO NOT EDIT — generated from commons/swagger/openapi-*.yaml by
# clients/ruby/bin/scaffold_resources. Edit the OpenAPI spec or the scaffold
# script instead.

module ApiEntreprise
  module Resources
    class Opqibi
      def initialize(client)
        @client = client
      end

      # Certification d'ingénierie OPQIBI
      # Logical endpoint: /opqibi/unites_legales/{siren}/certification_ingenierie
      # Versions available: [3] — default: 3
      def certification_ingenierie(siren, version: nil)
        Commons::Siren.validate!(siren, parameter: :siren)
        path =
          case version || 3
          when 3
          "/v3/opqibi/unites_legales/#{siren}/certification_ingenierie"
          else
            raise ArgumentError, "version #{version.inspect} not available for /opqibi/unites_legales/{siren}/certification_ingenierie; supported: [3]"
          end
        @client.get(path, params: {})
      end
    end
  end
end
