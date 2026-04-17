# frozen_string_literal: true
# DO NOT EDIT — generated from commons/swagger/openapi-*.yaml by
# clients/ruby/bin/scaffold_resources. Edit the OpenAPI spec or the scaffold
# script instead.

module ApiParticulier
  module Resources
    class GipMds
      def initialize(client)
        @client = client
      end

      # [FranceConnect] Statut service civique
      # Logical endpoint: /gip_mds/service_civique/france_connect
      # Versions available: [3] — default: 3
      def service_civique(version: nil)
        path =
          case version || 3
          when 3
          "/v3/gip_mds/service_civique/france_connect"
          else
            raise ArgumentError, "version #{version.inspect} not available for /gip_mds/service_civique/france_connect; supported: [3]"
          end
        @client.get(path, params: {})
      end

      # [Identité] Statut service civique
      # Logical endpoint: /gip_mds/service_civique/identite
      # Versions available: [3] — default: 3
      def service_civique_identite(version: nil, nom_naissance: nil, prenoms: nil, annee_date_naissance: nil, mois_date_naissance: nil, jour_date_naissance: nil)
        path =
          case version || 3
          when 3
          "/v3/gip_mds/service_civique/identite"
          else
            raise ArgumentError, "version #{version.inspect} not available for /gip_mds/service_civique/identite; supported: [3]"
          end
        @client.get(path, params: { "nomNaissance" => nom_naissance, "prenoms[]" => prenoms, "anneeDateNaissance" => annee_date_naissance, "moisDateNaissance" => mois_date_naissance, "jourDateNaissance" => jour_date_naissance }.compact)
      end
    end
  end
end
