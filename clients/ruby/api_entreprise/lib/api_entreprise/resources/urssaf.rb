# frozen_string_literal: true
# DO NOT EDIT — generated from commons/swagger/openapi-*.yaml by
# clients/ruby/bin/scaffold_resources. Edit the OpenAPI spec or the scaffold
# script instead.

module ApiEntreprise
  module Resources
    class Urssaf
      def initialize(client)
        @client = client
      end

      # Attestation de vigilance
      # Logical endpoint: /urssaf/unites_legales/{siren}/attestation_vigilance
      # Versions available: [3, 4] — default: 4
      def attestation_vigilance(siren, version: nil)
        Commons::Siren.validate!(siren, parameter: :siren)
        path =
          case version || 4
          when 3
          warn "[DEPRECATED] /v3/urssaf/unites_legales/{siren}/attestation_vigilance (#attestation_vigilance): marked deprecated in the OpenAPI spec.", uplevel: 1
          "/v3/urssaf/unites_legales/#{siren}/attestation_vigilance"
          when 4
          "/v4/urssaf/unites_legales/#{siren}/attestation_vigilance"
          else
            raise ArgumentError, "version #{version.inspect} not available for /urssaf/unites_legales/{siren}/attestation_vigilance; supported: [3, 4]"
          end
        @client.get(path, params: {})
      end
    end
  end
end
