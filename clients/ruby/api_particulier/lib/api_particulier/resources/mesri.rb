# frozen_string_literal: true
# DO NOT EDIT — generated from commons/swagger/openapi-*.yaml by
# clients/ruby/bin/scaffold_resources. Edit the OpenAPI spec or the scaffold
# script instead.

module ApiParticulier
  module Resources
    class Mesri
      def initialize(client)
        @client = client
      end

      # [FranceConnect] Statut étudiant
      # Logical endpoint: /mesri/statut_etudiant/france_connect
      # Versions available: [3] — default: 3
      def statut_etudiant(version: nil)
        path =
          case version || 3
          when 3
          "/v3/mesri/statut_etudiant/france_connect"
          else
            raise ArgumentError, "version #{version.inspect} not available for /mesri/statut_etudiant/france_connect; supported: [3]"
          end
        @client.get(path, params: {})
      end

      # [Identité] Statut étudiant
      # Logical endpoint: /mesri/statut_etudiant/identite
      # Versions available: [3] — default: 3
      def statut_etudiant_identite(version: nil, nom_naissance: nil, prenoms: nil, annee_date_naissance: nil, mois_date_naissance: nil, jour_date_naissance: nil, sexe_etat_civil: nil, code_cog_insee_commune_naissance: nil, nom_commune_naissance: nil, code_cog_insee_departement_naissance: nil)
        path =
          case version || 3
          when 3
          "/v3/mesri/statut_etudiant/identite"
          else
            raise ArgumentError, "version #{version.inspect} not available for /mesri/statut_etudiant/identite; supported: [3]"
          end
        @client.get(path, params: { "nomNaissance" => nom_naissance, "prenoms[]" => prenoms, "anneeDateNaissance" => annee_date_naissance, "moisDateNaissance" => mois_date_naissance, "jourDateNaissance" => jour_date_naissance, "sexeEtatCivil" => sexe_etat_civil, "codeCogInseeCommuneNaissance" => code_cog_insee_commune_naissance, "nomCommuneNaissance" => nom_commune_naissance, "codeCogInseeDepartementNaissance" => code_cog_insee_departement_naissance }.compact)
      end

      # [INE] Statut étudiant
      # Logical endpoint: /mesri/statut_etudiant/ine
      # Versions available: [3] — default: 3
      def ine(version: nil, ine: nil)
        path =
          case version || 3
          when 3
          "/v3/mesri/statut_etudiant/ine"
          else
            raise ArgumentError, "version #{version.inspect} not available for /mesri/statut_etudiant/ine; supported: [3]"
          end
        @client.get(path, params: { "ine" => ine }.compact)
      end
    end
  end
end
