# frozen_string_literal: true
# DO NOT EDIT — generated from commons/swagger/openapi-*.yaml by
# clients/ruby/bin/scaffold_resources. Edit the OpenAPI spec or the scaffold
# script instead.

module ApiEntreprise
  module Resources
    class Infogreffe
      def initialize(client)
        @client = client
      end

      # Extrait RCS
      # Logical endpoint: /infogreffe/rcs/unites_legales/{siren}/extrait_kbis
      # Versions available: [3] — default: 3
      def extrait_kbis(siren, version: nil)
        Commons::Siren.validate!(siren, parameter: :siren)
        path =
          case version || 3
          when 3
          "/v3/infogreffe/rcs/unites_legales/#{siren}/extrait_kbis"
          else
            raise ArgumentError, "version #{version.inspect} not available for /infogreffe/rcs/unites_legales/{siren}/extrait_kbis; supported: [3]"
          end
        @client.get(path, params: {})
      end

      # Mandataires sociaux
      # Logical endpoint: /infogreffe/rcs/unites_legales/{siren}/mandataires_sociaux
      # Versions available: [3] — default: 3
      def mandataires_sociaux(siren, version: nil)
        Commons::Siren.validate!(siren, parameter: :siren)
        path =
          case version || 3
          when 3
          "/v3/infogreffe/rcs/unites_legales/#{siren}/mandataires_sociaux"
          else
            raise ArgumentError, "version #{version.inspect} not available for /infogreffe/rcs/unites_legales/{siren}/mandataires_sociaux; supported: [3]"
          end
        @client.get(path, params: {})
      end
    end
  end
end
