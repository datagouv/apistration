# frozen_string_literal: true
# DO NOT EDIT — generated from commons/swagger/openapi-*.yaml by
# clients/ruby/bin/scaffold_resources. Edit the OpenAPI spec or the scaffold
# script instead.

module ApiParticulier
  module Resources
    class Dsnj
      def initialize(client)
        @client = client
      end

      # [FranceConnect] API Service national
      # Logical endpoint: /dsnj/service_national/france_connect
      # Versions available: [3] — default: 3
      def service_national(version: nil)
        path =
          case version || 3
          when 3
          "/v3/dsnj/service_national/france_connect"
          else
            raise ArgumentError, "version #{version.inspect} not available for /dsnj/service_national/france_connect; supported: [3]"
          end
        @client.get(path, params: {})
      end

      # [Identité] API Service national
      # Logical endpoint: /dsnj/service_national/identite
      # Versions available: [3] — default: 3
      def service_national_identite(version: nil, nom_naissance: nil, prenoms: nil, annee_date_naissance: nil, mois_date_naissance: nil, jour_date_naissance: nil, sexe_etat_civil: nil, code_cog_insee_commune_naissance: nil, code_cog_insee_pays_naissance: nil)
        path =
          case version || 3
          when 3
          "/v3/dsnj/service_national/identite"
          else
            raise ArgumentError, "version #{version.inspect} not available for /dsnj/service_national/identite; supported: [3]"
          end
        @client.get(path, params: { "nomNaissance" => nom_naissance, "prenoms[]" => prenoms, "anneeDateNaissance" => annee_date_naissance, "moisDateNaissance" => mois_date_naissance, "jourDateNaissance" => jour_date_naissance, "sexeEtatCivil" => sexe_etat_civil, "codeCogInseeCommuneNaissance" => code_cog_insee_commune_naissance, "codeCogInseePaysNaissance" => code_cog_insee_pays_naissance }.compact)
      end
    end
  end
end
