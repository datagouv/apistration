# frozen_string_literal: true
# DO NOT EDIT — generated from commons/swagger/openapi-*.yaml by
# clients/ruby/bin/scaffold_resources. Edit the OpenAPI spec or the scaffold
# script instead.

module ApiEntreprise
  module Resources
    class GipMds
      def initialize(client)
        @client = client
      end

      # Effectifs mensuels d'un établissement
      # Logical endpoint: /gip_mds/etablissements/{siret}/effectifs_mensuels/{month}/annee/{year}
      # Versions available: [3] — default: 3
      def annee(siret, year, month, version: nil, recipient: nil, context: nil, object: nil, profondeur: nil, nature_effectif: nil)
        Commons::Siret.validate!(siret, parameter: :siret)
        path =
          case version || 3
          when 3
          "/v3/gip_mds/etablissements/#{siret}/effectifs_mensuels/#{month}/annee/#{year}"
          else
            raise ArgumentError, "version #{version.inspect} not available for /gip_mds/etablissements/{siret}/effectifs_mensuels/{month}/annee/{year}; supported: [3]"
          end
        @client.get(path, params: { "recipient" => recipient, "context" => context, "object" => object, "profondeur" => profondeur, "nature_effectif" => nature_effectif }.compact)
      end

      # Effectifs annuels d'une unité légale
      # Logical endpoint: /gip_mds/unites_legales/{siren}/effectifs_annuels/{year}
      # Versions available: [3] — default: 3
      def effectifs_annuels(siren, year, version: nil, recipient: nil, context: nil, object: nil, nature_effectif: nil)
        Commons::Siren.validate!(siren, parameter: :siren)
        path =
          case version || 3
          when 3
          "/v3/gip_mds/unites_legales/#{siren}/effectifs_annuels/#{year}"
          else
            raise ArgumentError, "version #{version.inspect} not available for /gip_mds/unites_legales/{siren}/effectifs_annuels/{year}; supported: [3]"
          end
        @client.get(path, params: { "recipient" => recipient, "context" => context, "object" => object, "nature_effectif" => nature_effectif }.compact)
      end
    end
  end
end
