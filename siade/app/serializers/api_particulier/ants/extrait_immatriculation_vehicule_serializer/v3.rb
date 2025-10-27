class APIParticulier::ANTS::ExtraitImmatriculationVehiculeSerializer::V3 < APIParticulier::V3AndMore::BaseSerializer
  attribute :identite_particulier
  attribute :adresse_particulier, if: -> { scope?(:ants_extrait_immatriculation_vehicule_adresse_particulier) }
  attribute :statut_rattachement, if: -> { scope?(:ants_extrait_immatriculation_vehicule_statut_rattachement) }
  attribute :donnees_immatriculation_vehicule, if: -> { scope?(:ants_extrait_immatriculation_vehicule_donnees_immatriculation_vehicule) }
  attribute :caracteristiques_techniques_vehicule, if: -> { scope?(:ants_extrait_immatriculation_vehicule_caracteristiques_techniques_vehicule) }

  meta do |ctx|
    {
      identity_matching: {
        family_name: ctx.matchings&.try('familyname') ? 1.0 : 0.0,
        given_name: ctx.matchings&.try('givenname') ? 1.0 : 0.0,
        birth_date: ctx.matchings&.try('birthdate') ? 1.0 : 0.0,
        overall_match: ctx.matches || false
      }
    }
  end
end
