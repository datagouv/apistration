# frozen_string_literal: true
# DO NOT EDIT — generated from commons/swagger/openapi-*.yaml by
# clients/ruby/bin/scaffold_resources. Edit the OpenAPI spec or the scaffold
# script instead.

module ApiParticulier
  module Resources
    class Cnous
      def initialize(client)
        @client = client
      end

      # [FranceConnect] Statut étudiant boursier
      # Logical endpoint: /cnous/etudiant_boursier/france_connect
      # Versions available: [3, 4] — default: 4
      def etudiant_boursier(version: nil)
        path =
          case version || 4
          when 3
          warn "[DEPRECATED] /v3/cnous/etudiant_boursier/france_connect (#etudiant_boursier): marked deprecated in the OpenAPI spec.", uplevel: 1
          "/v3/cnous/etudiant_boursier/france_connect"
          when 4
          "/v4/cnous/etudiant_boursier/france_connect"
          else
            raise ArgumentError, "version #{version.inspect} not available for /cnous/etudiant_boursier/france_connect; supported: [3, 4]"
          end
        @client.get(path, params: {})
      end

      # [Identité] Statut étudiant boursier
      # Logical endpoint: /cnous/etudiant_boursier/identite
      # Versions available: [3, 4] — default: 4
      def etudiant_boursier_identite(version: nil, nom_naissance: nil, prenoms: nil, annee_date_naissance: nil, mois_date_naissance: nil, jour_date_naissance: nil, sexe_etat_civil: nil, code_cog_insee_commune_naissance: nil, nom_commune_naissance: nil, code_cog_insee_departement_naissance: nil)
        path =
          case version || 4
          when 3
          warn "[DEPRECATED] /v3/cnous/etudiant_boursier/identite (#etudiant_boursier_identite): marked deprecated in the OpenAPI spec.", uplevel: 1
          "/v3/cnous/etudiant_boursier/identite"
          when 4
          "/v4/cnous/etudiant_boursier/identite"
          else
            raise ArgumentError, "version #{version.inspect} not available for /cnous/etudiant_boursier/identite; supported: [3, 4]"
          end
        @client.get(path, params: { "nomNaissance" => nom_naissance, "prenoms[]" => prenoms, "anneeDateNaissance" => annee_date_naissance, "moisDateNaissance" => mois_date_naissance, "jourDateNaissance" => jour_date_naissance, "sexeEtatCivil" => sexe_etat_civil, "codeCogInseeCommuneNaissance" => code_cog_insee_commune_naissance, "nomCommuneNaissance" => nom_commune_naissance, "codeCogInseeDepartementNaissance" => code_cog_insee_departement_naissance }.compact)
      end

      # [INE] Statut étudiant boursier
      # Logical endpoint: /cnous/etudiant_boursier/ine
      # Versions available: [3, 4] — default: 4
      def ine(version: nil, ine: nil)
        path =
          case version || 4
          when 3
          warn "[DEPRECATED] /v3/cnous/etudiant_boursier/ine (#ine): marked deprecated in the OpenAPI spec.", uplevel: 1
          "/v3/cnous/etudiant_boursier/ine"
          when 4
          "/v4/cnous/etudiant_boursier/ine"
          else
            raise ArgumentError, "version #{version.inspect} not available for /cnous/etudiant_boursier/ine; supported: [3, 4]"
          end
        @client.get(path, params: { "ine" => ine }.compact)
      end
    end
  end
end
