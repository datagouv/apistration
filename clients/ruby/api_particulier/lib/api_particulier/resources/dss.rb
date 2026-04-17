# frozen_string_literal: true
# DO NOT EDIT — generated from commons/swagger/openapi-*.yaml by
# clients/ruby/bin/scaffold_resources. Edit the OpenAPI spec or the scaffold
# script instead.

module ApiParticulier
  module Resources
    class Dss
      def initialize(client)
        @client = client
      end

      # [FranceConnect] Statut allocation adulte handicapé (AAH)
      # Logical endpoint: /dss/allocation_adulte_handicape/france_connect
      # Versions available: [3] — default: 3
      def allocation_adulte_handicape(version: nil)
        path =
          case version || 3
          when 3
          "/v3/dss/allocation_adulte_handicape/france_connect"
          else
            raise ArgumentError, "version #{version.inspect} not available for /dss/allocation_adulte_handicape/france_connect; supported: [3]"
          end
        @client.get(path, params: {})
      end

      # [Identité] Statut allocation adulte handicapé (AAH)
      # Logical endpoint: /dss/allocation_adulte_handicape/identite
      # Versions available: [3] — default: 3
      def allocation_adulte_handicape_identite(version: nil, nom_naissance: nil, nom_usage: nil, prenoms: nil, annee_date_naissance: nil, mois_date_naissance: nil, jour_date_naissance: nil, sexe_etat_civil: nil, code_cog_insee_pays_naissance: nil, code_cog_insee_commune_naissance: nil, nom_commune_naissance: nil, code_cog_insee_departement_naissance: nil)
        path =
          case version || 3
          when 3
          "/v3/dss/allocation_adulte_handicape/identite"
          else
            raise ArgumentError, "version #{version.inspect} not available for /dss/allocation_adulte_handicape/identite; supported: [3]"
          end
        @client.get(path, params: { "nomNaissance" => nom_naissance, "nomUsage" => nom_usage, "prenoms[]" => prenoms, "anneeDateNaissance" => annee_date_naissance, "moisDateNaissance" => mois_date_naissance, "jourDateNaissance" => jour_date_naissance, "sexeEtatCivil" => sexe_etat_civil, "codeCogInseePaysNaissance" => code_cog_insee_pays_naissance, "codeCogInseeCommuneNaissance" => code_cog_insee_commune_naissance, "nomCommuneNaissance" => nom_commune_naissance, "codeCogInseeDepartementNaissance" => code_cog_insee_departement_naissance }.compact)
      end

      # [FranceConnect] Statut allocation d'éducation de l'enfant handicapé (AEEH)
      # Logical endpoint: /dss/allocation_enfant_handicape/france_connect
      # Versions available: [3] — default: 3
      def allocation_enfant_handicape(version: nil)
        path =
          case version || 3
          when 3
          "/v3/dss/allocation_enfant_handicape/france_connect"
          else
            raise ArgumentError, "version #{version.inspect} not available for /dss/allocation_enfant_handicape/france_connect; supported: [3]"
          end
        @client.get(path, params: {})
      end

      # [Identité] Statut allocation d'éducation de l'enfant handicapé (AEEH)
      # Logical endpoint: /dss/allocation_enfant_handicape/identite
      # Versions available: [3] — default: 3
      def allocation_enfant_handicape_identite(version: nil, nom_naissance: nil, nom_usage: nil, prenoms: nil, annee_date_naissance: nil, mois_date_naissance: nil, jour_date_naissance: nil, sexe_etat_civil: nil, code_cog_insee_pays_naissance: nil, code_cog_insee_commune_naissance: nil, nom_commune_naissance: nil, code_cog_insee_departement_naissance: nil)
        path =
          case version || 3
          when 3
          "/v3/dss/allocation_enfant_handicape/identite"
          else
            raise ArgumentError, "version #{version.inspect} not available for /dss/allocation_enfant_handicape/identite; supported: [3]"
          end
        @client.get(path, params: { "nomNaissance" => nom_naissance, "nomUsage" => nom_usage, "prenoms[]" => prenoms, "anneeDateNaissance" => annee_date_naissance, "moisDateNaissance" => mois_date_naissance, "jourDateNaissance" => jour_date_naissance, "sexeEtatCivil" => sexe_etat_civil, "codeCogInseePaysNaissance" => code_cog_insee_pays_naissance, "codeCogInseeCommuneNaissance" => code_cog_insee_commune_naissance, "nomCommuneNaissance" => nom_commune_naissance, "codeCogInseeDepartementNaissance" => code_cog_insee_departement_naissance }.compact)
      end

      # [FranceConnect] Statut allocation de soutien familial (ASF)
      # Logical endpoint: /dss/allocation_soutien_familial/france_connect
      # Versions available: [3] — default: 3
      def allocation_soutien_familial(version: nil)
        path =
          case version || 3
          when 3
          "/v3/dss/allocation_soutien_familial/france_connect"
          else
            raise ArgumentError, "version #{version.inspect} not available for /dss/allocation_soutien_familial/france_connect; supported: [3]"
          end
        @client.get(path, params: {})
      end

      # [Identité] Statut allocation de soutien familial (ASF)
      # Logical endpoint: /dss/allocation_soutien_familial/identite
      # Versions available: [3] — default: 3
      def allocation_soutien_familial_identite(version: nil, nom_naissance: nil, nom_usage: nil, prenoms: nil, annee_date_naissance: nil, mois_date_naissance: nil, jour_date_naissance: nil, sexe_etat_civil: nil, code_cog_insee_pays_naissance: nil, code_cog_insee_commune_naissance: nil, nom_commune_naissance: nil, code_cog_insee_departement_naissance: nil)
        path =
          case version || 3
          when 3
          "/v3/dss/allocation_soutien_familial/identite"
          else
            raise ArgumentError, "version #{version.inspect} not available for /dss/allocation_soutien_familial/identite; supported: [3]"
          end
        @client.get(path, params: { "nomNaissance" => nom_naissance, "nomUsage" => nom_usage, "prenoms[]" => prenoms, "anneeDateNaissance" => annee_date_naissance, "moisDateNaissance" => mois_date_naissance, "jourDateNaissance" => jour_date_naissance, "sexeEtatCivil" => sexe_etat_civil, "codeCogInseePaysNaissance" => code_cog_insee_pays_naissance, "codeCogInseeCommuneNaissance" => code_cog_insee_commune_naissance, "nomCommuneNaissance" => nom_commune_naissance, "codeCogInseeDepartementNaissance" => code_cog_insee_departement_naissance }.compact)
      end

      # [FranceConnect] Statut complémentaire santé solidaire (C2S)
      # Logical endpoint: /dss/complementaire_sante_solidaire/france_connect
      # Versions available: [3] — default: 3
      def complementaire_sante_solidaire(version: nil)
        path =
          case version || 3
          when 3
          "/v3/dss/complementaire_sante_solidaire/france_connect"
          else
            raise ArgumentError, "version #{version.inspect} not available for /dss/complementaire_sante_solidaire/france_connect; supported: [3]"
          end
        @client.get(path, params: {})
      end

      # [Identité] Statut complémentaire santé solidaire (C2S)
      # Logical endpoint: /dss/complementaire_sante_solidaire/identite
      # Versions available: [3] — default: 3
      def complementaire_sante_solidaire_identite(version: nil, nom_naissance: nil, nom_usage: nil, prenoms: nil, annee_date_naissance: nil, mois_date_naissance: nil, jour_date_naissance: nil, sexe_etat_civil: nil, code_cog_insee_pays_naissance: nil, code_cog_insee_commune_naissance: nil, nom_commune_naissance: nil, code_cog_insee_departement_naissance: nil)
        path =
          case version || 3
          when 3
          "/v3/dss/complementaire_sante_solidaire/identite"
          else
            raise ArgumentError, "version #{version.inspect} not available for /dss/complementaire_sante_solidaire/identite; supported: [3]"
          end
        @client.get(path, params: { "nomNaissance" => nom_naissance, "nomUsage" => nom_usage, "prenoms[]" => prenoms, "anneeDateNaissance" => annee_date_naissance, "moisDateNaissance" => mois_date_naissance, "jourDateNaissance" => jour_date_naissance, "sexeEtatCivil" => sexe_etat_civil, "codeCogInseePaysNaissance" => code_cog_insee_pays_naissance, "codeCogInseeCommuneNaissance" => code_cog_insee_commune_naissance, "nomCommuneNaissance" => nom_commune_naissance, "codeCogInseeDepartementNaissance" => code_cog_insee_departement_naissance }.compact)
      end

      # [FranceConnect] Participation familiale EAJE
      # Logical endpoint: /dss/participation_familiale_eaje/france_connect
      # Versions available: [3] — default: 3
      def participation_familiale_eaje(version: nil)
        path =
          case version || 3
          when 3
          "/v3/dss/participation_familiale_eaje/france_connect"
          else
            raise ArgumentError, "version #{version.inspect} not available for /dss/participation_familiale_eaje/france_connect; supported: [3]"
          end
        @client.get(path, params: {})
      end

      # [Identité] Participation familiale EAJE
      # Logical endpoint: /dss/participation_familiale_eaje/identite
      # Versions available: [3] — default: 3
      def participation_familiale_eaje_identite(version: nil, nom_naissance: nil, nom_usage: nil, prenoms: nil, annee_date_naissance: nil, mois_date_naissance: nil, jour_date_naissance: nil, sexe_etat_civil: nil, code_cog_insee_pays_naissance: nil, code_cog_insee_commune_naissance: nil, nom_commune_naissance: nil, code_cog_insee_departement_naissance: nil)
        path =
          case version || 3
          when 3
          "/v3/dss/participation_familiale_eaje/identite"
          else
            raise ArgumentError, "version #{version.inspect} not available for /dss/participation_familiale_eaje/identite; supported: [3]"
          end
        @client.get(path, params: { "nomNaissance" => nom_naissance, "nomUsage" => nom_usage, "prenoms[]" => prenoms, "anneeDateNaissance" => annee_date_naissance, "moisDateNaissance" => mois_date_naissance, "jourDateNaissance" => jour_date_naissance, "sexeEtatCivil" => sexe_etat_civil, "codeCogInseePaysNaissance" => code_cog_insee_pays_naissance, "codeCogInseeCommuneNaissance" => code_cog_insee_commune_naissance, "nomCommuneNaissance" => nom_commune_naissance, "codeCogInseeDepartementNaissance" => code_cog_insee_departement_naissance }.compact)
      end

      # [FranceConnect] Statut prime d'activité
      # Logical endpoint: /dss/prime_activite/france_connect
      # Versions available: [3] — default: 3
      def prime_activite(version: nil)
        path =
          case version || 3
          when 3
          "/v3/dss/prime_activite/france_connect"
          else
            raise ArgumentError, "version #{version.inspect} not available for /dss/prime_activite/france_connect; supported: [3]"
          end
        @client.get(path, params: {})
      end

      # [Identité] Statut prime d'activité
      # Logical endpoint: /dss/prime_activite/identite
      # Versions available: [3] — default: 3
      def prime_activite_identite(version: nil, nom_naissance: nil, nom_usage: nil, prenoms: nil, annee_date_naissance: nil, mois_date_naissance: nil, jour_date_naissance: nil, sexe_etat_civil: nil, code_cog_insee_pays_naissance: nil, code_cog_insee_commune_naissance: nil, nom_commune_naissance: nil, code_cog_insee_departement_naissance: nil)
        path =
          case version || 3
          when 3
          "/v3/dss/prime_activite/identite"
          else
            raise ArgumentError, "version #{version.inspect} not available for /dss/prime_activite/identite; supported: [3]"
          end
        @client.get(path, params: { "nomNaissance" => nom_naissance, "nomUsage" => nom_usage, "prenoms[]" => prenoms, "anneeDateNaissance" => annee_date_naissance, "moisDateNaissance" => mois_date_naissance, "jourDateNaissance" => jour_date_naissance, "sexeEtatCivil" => sexe_etat_civil, "codeCogInseePaysNaissance" => code_cog_insee_pays_naissance, "codeCogInseeCommuneNaissance" => code_cog_insee_commune_naissance, "nomCommuneNaissance" => nom_commune_naissance, "codeCogInseeDepartementNaissance" => code_cog_insee_departement_naissance }.compact)
      end

      # [FranceConnect] Quotient familial CAF & MSA
      # Logical endpoint: /dss/quotient_familial/france_connect
      # Versions available: [3] — default: 3
      def quotient_familial(version: nil, annee: nil, mois: nil)
        path =
          case version || 3
          when 3
          "/v3/dss/quotient_familial/france_connect"
          else
            raise ArgumentError, "version #{version.inspect} not available for /dss/quotient_familial/france_connect; supported: [3]"
          end
        @client.get(path, params: { "annee" => annee, "mois" => mois }.compact)
      end

      # [Identité] Quotient familial CAF & MSA
      # Logical endpoint: /dss/quotient_familial/identite
      # Versions available: [3] — default: 3
      def quotient_familial_identite(version: nil, nom_naissance: nil, nom_usage: nil, prenoms: nil, annee_date_naissance: nil, mois_date_naissance: nil, jour_date_naissance: nil, sexe_etat_civil: nil, code_cog_insee_pays_naissance: nil, code_cog_insee_commune_naissance: nil, nom_commune_naissance: nil, code_cog_insee_departement_naissance: nil, annee: nil, mois: nil)
        path =
          case version || 3
          when 3
          "/v3/dss/quotient_familial/identite"
          else
            raise ArgumentError, "version #{version.inspect} not available for /dss/quotient_familial/identite; supported: [3]"
          end
        @client.get(path, params: { "nomNaissance" => nom_naissance, "nomUsage" => nom_usage, "prenoms[]" => prenoms, "anneeDateNaissance" => annee_date_naissance, "moisDateNaissance" => mois_date_naissance, "jourDateNaissance" => jour_date_naissance, "sexeEtatCivil" => sexe_etat_civil, "codeCogInseePaysNaissance" => code_cog_insee_pays_naissance, "codeCogInseeCommuneNaissance" => code_cog_insee_commune_naissance, "nomCommuneNaissance" => nom_commune_naissance, "codeCogInseeDepartementNaissance" => code_cog_insee_departement_naissance, "annee" => annee, "mois" => mois }.compact)
      end

      # [FranceConnect] Statut revenu de solidarité active (RSA)
      # Logical endpoint: /dss/revenu_solidarite_active/france_connect
      # Versions available: [3] — default: 3
      def revenu_solidarite_active(version: nil)
        path =
          case version || 3
          when 3
          "/v3/dss/revenu_solidarite_active/france_connect"
          else
            raise ArgumentError, "version #{version.inspect} not available for /dss/revenu_solidarite_active/france_connect; supported: [3]"
          end
        @client.get(path, params: {})
      end

      # [Identité] Statut revenu de solidarité active (RSA)
      # Logical endpoint: /dss/revenu_solidarite_active/identite
      # Versions available: [3] — default: 3
      def revenu_solidarite_active_identite(version: nil, nom_naissance: nil, nom_usage: nil, prenoms: nil, annee_date_naissance: nil, mois_date_naissance: nil, jour_date_naissance: nil, sexe_etat_civil: nil, code_cog_insee_pays_naissance: nil, code_cog_insee_commune_naissance: nil, nom_commune_naissance: nil, code_cog_insee_departement_naissance: nil)
        path =
          case version || 3
          when 3
          "/v3/dss/revenu_solidarite_active/identite"
          else
            raise ArgumentError, "version #{version.inspect} not available for /dss/revenu_solidarite_active/identite; supported: [3]"
          end
        @client.get(path, params: { "nomNaissance" => nom_naissance, "nomUsage" => nom_usage, "prenoms[]" => prenoms, "anneeDateNaissance" => annee_date_naissance, "moisDateNaissance" => mois_date_naissance, "jourDateNaissance" => jour_date_naissance, "sexeEtatCivil" => sexe_etat_civil, "codeCogInseePaysNaissance" => code_cog_insee_pays_naissance, "codeCogInseeCommuneNaissance" => code_cog_insee_commune_naissance, "nomCommuneNaissance" => nom_commune_naissance, "codeCogInseeDepartementNaissance" => code_cog_insee_departement_naissance }.compact)
      end
    end
  end
end
