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
      # Versions available: [3, 4, 5] — default: 5
      def etudiant_boursier(version: nil, recipient: nil, delegation_id: nil, campaign_year: nil)
        path =
          case version || 5
          when 3
          warn "[DEPRECATED] /v3/cnous/etudiant_boursier/france_connect (#etudiant_boursier): marked deprecated in the OpenAPI spec.", uplevel: 1
          "/v3/cnous/etudiant_boursier/france_connect"
          when 4
          warn "[DEPRECATED] /v4/cnous/etudiant_boursier/france_connect (#etudiant_boursier): marked deprecated in the OpenAPI spec.", uplevel: 1
          "/v4/cnous/etudiant_boursier/france_connect"
          when 5
          "/v5/cnous/etudiant_boursier/france_connect"
          else
            raise ArgumentError, "version #{version.inspect} not available for /cnous/etudiant_boursier/france_connect; supported: [3, 4, 5]"
          end
        @client.get(path, params: { "recipient" => recipient, "delegation_id" => delegation_id, "campaignYear" => campaign_year }.compact)
      end

      # [Identité] Statut étudiant boursier
      # Logical endpoint: /cnous/etudiant_boursier/identite
      # Versions available: [3, 4, 5] — default: 5
      def etudiant_boursier_identite(version: nil, recipient: nil, delegation_id: nil, nom_naissance:, prenoms:, annee_date_naissance:, mois_date_naissance:, jour_date_naissance:, sexe_etat_civil: nil, code_cog_insee_commune_naissance: nil, nom_commune_naissance: nil, code_cog_insee_departement_naissance: nil, campaign_year: nil)
        path =
          case version || 5
          when 3
          warn "[DEPRECATED] /v3/cnous/etudiant_boursier/identite (#etudiant_boursier_identite): marked deprecated in the OpenAPI spec.", uplevel: 1
          "/v3/cnous/etudiant_boursier/identite"
          when 4
          warn "[DEPRECATED] /v4/cnous/etudiant_boursier/identite (#etudiant_boursier_identite): marked deprecated in the OpenAPI spec.", uplevel: 1
          "/v4/cnous/etudiant_boursier/identite"
          when 5
          "/v5/cnous/etudiant_boursier/identite"
          else
            raise ArgumentError, "version #{version.inspect} not available for /cnous/etudiant_boursier/identite; supported: [3, 4, 5]"
          end
        @client.get(path, params: { "recipient" => recipient, "delegation_id" => delegation_id, "nomNaissance" => nom_naissance, "prenoms" => prenoms, "anneeDateNaissance" => annee_date_naissance, "moisDateNaissance" => mois_date_naissance, "jourDateNaissance" => jour_date_naissance, "sexeEtatCivil" => sexe_etat_civil, "codeCogInseeCommuneNaissance" => code_cog_insee_commune_naissance, "nomCommuneNaissance" => nom_commune_naissance, "codeCogInseeDepartementNaissance" => code_cog_insee_departement_naissance, "campaignYear" => campaign_year }.compact)
      end

      # [INE] Statut étudiant boursier
      # Logical endpoint: /cnous/etudiant_boursier/ine
      # Versions available: [3, 4, 5] — default: 5
      def ine(version: nil, recipient: nil, delegation_id: nil, ine:, campaign_year: nil)
        path =
          case version || 5
          when 3
          warn "[DEPRECATED] /v3/cnous/etudiant_boursier/ine (#ine): marked deprecated in the OpenAPI spec.", uplevel: 1
          "/v3/cnous/etudiant_boursier/ine"
          when 4
          warn "[DEPRECATED] /v4/cnous/etudiant_boursier/ine (#ine): marked deprecated in the OpenAPI spec.", uplevel: 1
          "/v4/cnous/etudiant_boursier/ine"
          when 5
          "/v5/cnous/etudiant_boursier/ine"
          else
            raise ArgumentError, "version #{version.inspect} not available for /cnous/etudiant_boursier/ine; supported: [3, 4, 5]"
          end
        @client.get(path, params: { "recipient" => recipient, "delegation_id" => delegation_id, "ine" => ine, "campaignYear" => campaign_year }.compact)
      end
    end
  end
end
