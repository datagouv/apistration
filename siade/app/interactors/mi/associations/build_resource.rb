class MI::Associations::BuildResource < BuildResource
  protected

  def resource_attributes
    @asso_hash = xml_body_as_hash[:asso]

    {
      rna_id: @asso_hash[:identite][:id_rna],
      titre: @asso_hash[:identite][:nom],
      objet: @asso_hash[:activites][:objet],
      siret: @siret,
      siret_siege_social: @asso_hash[:identite][:id_siret_siege],
      date_creation: @asso_hash[:identite][:date_creat],
      date_declaration: @asso_hash[:identite][:date_modif_rna],
      date_publication: @asso_hash[:identite][:date_pub_jo],
      date_dissolution: @asso_hash[:identite][:date_dissolution],
      adresse_siege:,
      etat: @asso_hash[:identite][:active],
      groupement: @asso_hash[:identite][:groupement],
      mise_a_jour: @asso_hash[:identite][:date_modif_rna]
    }
  end

  private

  # rubocop:disable Metrics/AbcSize
  def adresse_siege
    adresse_siege_complement_1 = @asso_hash[:coordonnees][:adresse_siege][:cplt_1]
    adresse_siege_complement_2 = @asso_hash[:coordonnees][:adresse_siege][:cplt_2]
    adresse_siege_complement_3 = @asso_hash[:coordonnees][:adresse_siege][:cplt_3]

    {
      complement: [adresse_siege_complement_1, adresse_siege_complement_2, adresse_siege_complement_3].join(' '),
      numero_voie: @asso_hash[:coordonnees][:adresse_siege][:num_voie],
      type_voie: @asso_hash[:coordonnees][:adresse_siege][:type_voie],
      libelle_voie: @asso_hash[:coordonnees][:adresse_siege][:voie],
      distribution: @asso_hash[:coordonnees][:adresse_siege][:bp],
      code_insee: @asso_hash[:coordonnees][:adresse_siege][:code_insee],
      code_postal: @asso_hash[:coordonnees][:adresse_siege][:cp],
      commune: @asso_hash[:coordonnees][:adresse_siege][:commune]
    }
  end
  # rubocop:enable Metrics/AbcSize
end
