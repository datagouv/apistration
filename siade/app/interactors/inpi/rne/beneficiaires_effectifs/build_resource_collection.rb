class INPI::RNE::BeneficiairesEffectifs::BuildResourceCollection < BuildResourceCollection
  def items
    beneficiaires_avec_modalites
  end

  def beneficiaires_avec_modalites
    all_items.reject { |item| item['modalite'].nil? }
  end

  def beneficiaires_sans_modalites_uuids
    all_items
      .select { |item| item['modalite'].nil? }
      .map { |item| Resource.new(resource_attributes(item)).to_h }
      .pluck(:beneficiaire_uuid)
  end

  def all_items
    json_body['formality']['content']['personneMorale']['beneficiairesEffectifs']
  end

  def items_context
    {
      count: items.count,
      beneficiaires_sans_modalites_uuids:
    }
  end

  def resource_attributes(raw_beneficiaire_effectif)
    personne_physique_attributes = raw_beneficiaire_effectif['beneficiaire']['descriptionPersonne']

    birth_date_parts = personne_physique_attributes.try(:[], 'dateDeNaissance')&.split('-')
    modalites_attributes = raw_beneficiaire_effectif['modalite']

    {
      beneficiaire_uuid: raw_beneficiaire_effectif['beneficiaireId'],
      nom: personne_physique_attributes.try(:[], 'nom')&.upcase,
      nom_usage: personne_physique_attributes.try(:[], 'nomUsage').try(:upcase),
      prenoms: personne_physique_attributes.try(:[], 'prenoms')&.map(&:upcase),
      date_naissance: {
        annee: birth_date_parts&.first,
        mois: birth_date_parts&.second
      },
      nationalite: personne_physique_attributes.try(:[], 'nationalite'),
      pays_residence: raw_beneficiaire_effectif['beneficiaire']['adresseDomicile'].try(:[], 'pays'),
      modalites: build_modalites(modalites_attributes)
    }
  end

  private

  # rubocop:disable Metrics/MethodLength,Metrics/AbcSize
  def build_modalites(modalites_attributes)
    {
      detention_de_capital: {
        parts_totale: modalites_attributes.try(:[], 'detentionPartTotale'),
        parts_directes: {
          detention: modalites_attributes.try(:[], 'detentionPartDirecte'),
          pleine_propriete: modalites_attributes.try(:[], 'partsDirectesPleinePropriete'),
          nue_propriete: modalites_attributes.try(:[], 'partsDirectesNuePropriete')
        },
        parts_indirectes: {
          detention: modalites_attributes.try(:[], 'detentionPartIndirecte'),
          par_indivision: {
            total: modalites_attributes.try(:[], 'partsIndirectesIndivision'),
            pleine_propriete: modalites_attributes.try(:[], 'partsIndirectesIndivisionPleinePropriete'),
            nue_propriete: modalites_attributes.try(:[], 'partsIndirectesIndivisionNuePropriete')
          },
          via_personnes_morales: {
            total: modalites_attributes.try(:[], 'partsIndirectesPersonnesMorales'),
            pleine_propriete: modalites_attributes.try(:[], 'partsIndirectesPmoralesPleinePropriete'),
            nue_propriete: modalites_attributes.try(:[], 'partsIndirectesPmoralesNuePropriete')
          }
        }
      },
      vocation_a_devenir_titulaire_de_parts: {
        parts_directes: {
          pleine_propriete: modalites_attributes.try(:[], 'vocationTitulaireDirectePleinePropriete'),
          nue_propriete: modalites_attributes.try(:[], 'vocationTitulaireDirecteNuePropriete')
        },
        parts_indirectes: {
          par_indivision: {
            total: modalites_attributes.try(:[], 'vocationTitulaireIndirecteIndivision'),
            pleine_propriete: modalites_attributes.try(:[], 'vocationTitulaireIndirectePleinePropriete'),
            nue_propriete: modalites_attributes.try(:[], 'vocationTitulaireIndirecteNuePropriete')
          },
          via_personnes_morales: {
            total: modalites_attributes.try(:[], 'vocationTitulaireIndirectePersonnesMorales'),
            pleine_propriete: modalites_attributes.try(:[], 'vocationTitulaireIndirectePmoralesPleinePropriete'),
            nue_propriete: modalites_attributes.try(:[], 'vocationTitulaireIndirectePmoralesNuePropriete')
          }
        }
      },
      droits_de_vote: {
        total: modalites_attributes.try(:[], 'detentionVoteTotal'),
        directes: {
          detention: modalites_attributes.try(:[], 'detentionVoteDirecte'),
          pleine_propriete: modalites_attributes.try(:[], 'voteDirectePleinePropriete'),
          nue_propriete: modalites_attributes.try(:[], 'voteDirecteNuePropriete'),
          usufruit: modalites_attributes.try(:[], 'voteDirecteUsufruit')
        },
        indirectes: {
          detention: modalites_attributes.try(:[], 'detentionVoteIndirecte'),
          par_indivision: {
            total: modalites_attributes.try(:[], 'voteIndirecteIndivision'),
            pleine_propriete: modalites_attributes.try(:[], 'voteIndirecteIndivisionPleinePropriete'),
            nue_propriete: modalites_attributes.try(:[], 'voteIndirecteIndivisionNuePropriete'),
            usufruit: modalites_attributes.try(:[], 'voteIndirecteIndivisionUsufruit')
          },
          via_personnes_morales: {
            total: modalites_attributes.try(:[], 'voteIndirectePersonnesMorales'),
            pleine_propriete: modalites_attributes.try(:[], 'voteIndirectePmoralesPleinePropriete'),
            nue_propriete: modalites_attributes.try(:[], 'voteIndirectePmoralesNuePropriete'),
            usufruit: modalites_attributes.try(:[], 'voteIndirectePmoralesUsufruit')
          }
        }
      },
      pouvoirs_de_controle: {
        decision_ag: modalites_attributes.try(:[], 'detentionPouvoirDecisionAG'),
        nommage_membres_conseil_administratif: modalites_attributes.try(:[], 'detentionPouvoirNommageMembresConseilAdmin'),
        autres: modalites_attributes.try(:[], 'detentionAutresMoyensControle')
      },
      representant_legal: modalites_attributes.try(:[], 'beneficiaireRepresentantLegal'),
      representant_legal_placement_sans_gestion_deleguee: modalites_attributes.try(:[], 'representantLegalPlacementSansGestionDelegue')
    }
  end
  # rubocop:enable Metrics/MethodLength,Metrics/AbcSize
end
