# frozen_string_literal: true
# DO NOT EDIT — generated from commons/swagger/openapi-*.yaml by
# clients/ruby/bin/scaffold_resources. Edit the OpenAPI spec or the scaffold
# script instead.

module ApiParticulier
  module Resources
    class Cnav
      def initialize(client)
        @client = client
      end

      # [FranceConnect] Statut allocation de rentrée scolaire (ARS)
      # Logical endpoint: /dss/allocation_rentree_scolaire/france_connect
      # Versions available: [3] — default: 3
      def allocation_rentree_scolaire(version: nil, recipient: nil)
        path =
          case version || 3
          when 3
          "/v3/dss/allocation_rentree_scolaire/france_connect"
          else
            raise ArgumentError, "version #{version.inspect} not available for /dss/allocation_rentree_scolaire/france_connect; supported: [3]"
          end
        @client.get(path, params: { "recipient" => recipient }.compact)
      end

      # [Identité] Statut allocation de rentrée scolaire (ARS)
      # Logical endpoint: /dss/allocation_rentree_scolaire/identite
      # Versions available: [3] — default: 3
      def allocation_rentree_scolaire_identite(version: nil, recipient: nil, nom_naissance:, nom_usage: nil, prenoms:, annee_date_naissance: nil, mois_date_naissance: nil, jour_date_naissance: nil, sexe_etat_civil: nil, code_cog_insee_pays_naissance:, code_cog_insee_commune_naissance: nil, nom_commune_naissance: nil, code_cog_insee_departement_naissance: nil)
        path =
          case version || 3
          when 3
          "/v3/dss/allocation_rentree_scolaire/identite"
          else
            raise ArgumentError, "version #{version.inspect} not available for /dss/allocation_rentree_scolaire/identite; supported: [3]"
          end
        @client.get(path, params: { "recipient" => recipient, "nomNaissance" => nom_naissance, "nomUsage" => nom_usage, "prenoms" => prenoms, "anneeDateNaissance" => annee_date_naissance, "moisDateNaissance" => mois_date_naissance, "jourDateNaissance" => jour_date_naissance, "sexeEtatCivil" => sexe_etat_civil, "codeCogInseePaysNaissance" => code_cog_insee_pays_naissance, "codeCogInseeCommuneNaissance" => code_cog_insee_commune_naissance, "nomCommuneNaissance" => nom_commune_naissance, "codeCogInseeDepartementNaissance" => code_cog_insee_departement_naissance }.compact)
      end
    end
  end
end
