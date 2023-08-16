class INPI::RNE::BeneficiairesEffectifs::BuildResourceCollection < BuildResourceCollection
  def items
    json_body['formality']['content']['personneMorale']['beneficiairesEffectifs']
  end

  def items_context
    {
      count: items.count
    }
  end

  def resource_attributes(raw_beneficiaire_effectif)
    personne_physique_attributes = raw_beneficiaire_effectif['beneficiaire']['descriptionPersonne']
    birth_date_parts = personne_physique_attributes['dateDeNaissance'].split('-')
    modalites_attributes = raw_beneficiaire_effectif['modalite']

    {
      nom: personne_physique_attributes['nom'].upcase,
      nom_usage: personne_physique_attributes['nomUsage'].try(:upcase),
      prenoms: personne_physique_attributes['prenoms'].map(&:upcase),
      date_naissance: {
        annee: birth_date_parts[0],
        mois: birth_date_parts[1]
      },
      modalites: build_modalites(modalites_attributes)
    }
  end

  private

  # rubocop:disable Metrics/MethodLength,Metrics/AbcSize
  def build_modalites(modalites_attributes)
    {
      detention_de_capital: {
        parts_totale: modalites_attributes['detentionPartTotale'],
        parts_directes: {
          detention: modalites_attributes['detentionPartDirecte'],
          pleine_propriete: modalites_attributes['partsDirectesPleinePropriete'],
          nue_propriete: modalites_attributes['partsDirectesNuePropriete']
        },
        parts_indirectes: {
          detention: modalites_attributes['detentionPartIndirecte'],
          par_indivision: {
            total: modalites_attributes['partsIndirectesIndivision'],
            pleine_propriete: modalites_attributes['partsIndirectesIndivisionPleinePropriete'],
            nue_propriete: modalites_attributes['partsIndirectesIndivisionNuePropriete']
          },
          via_personnes_morales: {
            total: modalites_attributes['partsIndirectesPersonnesMorales'],
            pleine_propriete: modalites_attributes['partsIndirectesPmoralesPleinePropriete'],
            nue_propriete: modalites_attributes['partsIndirectesPmoralesNuePropriete']
          }
        }
      },
      vocation_a_devenir_titulaire_de_parts: {
        parts_directes: {
          pleine_propriete: modalites_attributes['vocationTitulaireDirectePleinePropriete'],
          nue_propriete: modalites_attributes['vocationTitulaireDirecteNuePropriete']
        },
        parts_indirectes: {
          par_indivision: {
            total: modalites_attributes['vocationTitulaireIndirecteIndivision'],
            pleine_propriete: modalites_attributes['vocationTitulaireIndirectePleinePropriete'],
            nue_propriete: modalites_attributes['vocationTitulaireIndirecteNuePropriete']
          },
          via_personnes_morales: {
            total: modalites_attributes['vocationTitulaireIndirectePersonnesMorales'],
            pleine_propriete: modalites_attributes['vocationTitulaireIndirectePmoralesPleinePropriete'],
            nue_propriete: modalites_attributes['vocationTitulaireIndirectePmoralesNuePropriete']
          }
        }
      },
      droits_de_vote: {
        total: modalites_attributes['detentionVoteTotal'],
        directes: {
          detention: modalites_attributes['detentionVoteDirecte'],
          pleine_propriete: modalites_attributes['voteDirectePleinePropriete'],
          nue_propriete: modalites_attributes['voteDirecteNuePropriete'],
          usufruit: modalites_attributes['voteDirecteUsufruit']
        },
        indirectes: {
          detention: modalites_attributes['detentionVoteIndirecte'],
          par_indivision: {
            total: modalites_attributes['voteIndirecteIndivision'],
            pleine_propriete: modalites_attributes['voteIndirecteIndivisionPleinePropriete'],
            nue_propriete: modalites_attributes['voteIndirecteIndivisionNuePropriete'],
            usufruit: modalites_attributes['voteIndirecteIndivisionUsufruit']
          },
          via_personnes_morales: {
            total: modalites_attributes['voteIndirectePersonnesMorales'],
            pleine_propriete: modalites_attributes['voteIndirectePmoralesPleinePropriete'],
            nue_propriete: modalites_attributes['voteIndirectePmoralesNuePropriete'],
            usufruit: modalites_attributes['voteIndirectePmoralesUsufruit']
          }
        }
      },
      pouvoirs_de_controle: {
        decision_ag: modalites_attributes['detentionPouvoirDecisionAG'],
        nommage_membres_conseil_administratif: modalites_attributes['detentionPouvoirNommageMembresConseilAdmin'],
        autres: modalites_attributes['detentionAutresMoyensControle']
      },
      representant_legal: modalites_attributes['beneficiaireRepresentantLegal'],
      representant_legal_placement_sans_gestion_deleguee: modalites_attributes['representantLegalPlacementSansGestionDelegue']
    }
  end
  # rubocop:enable Metrics/MethodLength,Metrics/AbcSize
end
