# frozen_string_literal: true
# DO NOT EDIT — generated from commons/swagger/openapi-*.yaml by
# clients/ruby/bin/scaffold_resources. Edit the OpenAPI spec or the scaffold
# script instead.

module ApiEntreprise
  module Resources
    class Inpi
      def initialize(client)
        @client = client
      end

      # Actes et bilans
      # Logical endpoint: /inpi/rne/unites_legales/open_data/{siren}/actes_bilans
      # Versions available: [3] — default: 3
      def actes_bilans(siren, version: nil)
        Commons::Siren.validate!(siren, parameter: :siren)
        path =
          case version || 3
          when 3
          "/v3/inpi/rne/unites_legales/open_data/#{siren}/actes_bilans"
          else
            raise ArgumentError, "version #{version.inspect} not available for /inpi/rne/unites_legales/open_data/{siren}/actes_bilans; supported: [3]"
          end
        @client.get(path, params: {})
      end

      # Bénéficiaires effectifs
      # Logical endpoint: /inpi/rne/unites_legales/{siren}/beneficiaires_effectifs
      # Versions available: [3] — default: 3
      def beneficiaires_effectifs(siren, version: nil)
        Commons::Siren.validate!(siren, parameter: :siren)
        path =
          case version || 3
          when 3
          "/v3/inpi/rne/unites_legales/#{siren}/beneficiaires_effectifs"
          else
            raise ArgumentError, "version #{version.inspect} not available for /inpi/rne/unites_legales/{siren}/beneficiaires_effectifs; supported: [3]"
          end
        @client.get(path, params: {})
      end

      # Attestation d'immatriculation RNE
      # Logical endpoint: /inpi/rne/unites_legales/{siren}/extrait_rne
      # Versions available: [3] — default: 3
      def extrait_rne(siren, version: nil)
        Commons::Siren.validate!(siren, parameter: :siren)
        path =
          case version || 3
          when 3
          "/v3/inpi/rne/unites_legales/#{siren}/extrait_rne"
          else
            raise ArgumentError, "version #{version.inspect} not available for /inpi/rne/unites_legales/{siren}/extrait_rne; supported: [3]"
          end
        @client.get(path, params: {})
      end
    end
  end
end
