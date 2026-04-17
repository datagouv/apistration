# frozen_string_literal: true
# DO NOT EDIT — generated from commons/swagger/openapi-*.yaml by
# clients/ruby/bin/scaffold_resources. Edit the OpenAPI spec or the scaffold
# script instead.

module ApiParticulier
  module Resources
    class Men
      def initialize(client)
        @client = client
      end

      # Statut élève scolarisé et boursier
      # Logical endpoint: /men/scolarites/identite
      # Versions available: [3, 4, 5] — default: 5
      def scolarites(version: nil, nom_naissance: nil, prenoms: nil, sexe_etat_civil: nil, annee_date_naissance: nil, mois_date_naissance: nil, jour_date_naissance: nil, code_etablissement: nil, annee_scolaire: nil, degre_etablissement: nil, codes_bcn_departements: nil, codes_bcn_regions: nil)
        path =
          case version || 5
          when 3
          warn "[DEPRECATED] /v3/men/scolarites/identite (#scolarites): marked deprecated in the OpenAPI spec.", uplevel: 1
          "/v3/men/scolarites/identite"
          when 4
          warn "[DEPRECATED] /v4/men/scolarites/identite (#scolarites): marked deprecated in the OpenAPI spec.", uplevel: 1
          "/v4/men/scolarites/identite"
          when 5
          "/v5/men/scolarites/identite"
          else
            raise ArgumentError, "version #{version.inspect} not available for /men/scolarites/identite; supported: [3, 4, 5]"
          end
        @client.get(path, params: { "nomNaissance" => nom_naissance, "prenoms[]" => prenoms, "sexeEtatCivil" => sexe_etat_civil, "anneeDateNaissance" => annee_date_naissance, "moisDateNaissance" => mois_date_naissance, "jourDateNaissance" => jour_date_naissance, "codeEtablissement" => code_etablissement, "anneeScolaire" => annee_scolaire, "degreEtablissement" => degre_etablissement, "codesBcnDepartements[]" => codes_bcn_departements, "codesBcnRegions[]" => codes_bcn_regions }.compact)
      end
    end
  end
end
