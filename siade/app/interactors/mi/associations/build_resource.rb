class MI::Associations::BuildResource < BuildResource
  protected

  def resource_attributes
    @siret = id if Siret.new(context.id).valid?
    @id = id if RNAId.new(context.id).valid?

    @asso_hash = xml_body_as_hash[:asso]

    @id ||= @asso_hash[:identite][:id_rna]

    {
      id:          @id,
      association: association
    }
  end

  private

  def association
    {
      id:                      @id,
      titre:                   @asso_hash[:identite][:nom],
      objet:                   @asso_hash[:activites][:objet],
      siret:                   @siret,
      siret_siege_social:      @asso_hash[:identite][:id_siret_siege],
      date_creation:           @asso_hash[:identite][:date_creat],
      date_declaration:        @asso_hash[:identite][:date_modif_rna],
      date_publication:        @asso_hash[:identite][:date_pub_jo],
      date_dissolution:        @asso_hash[:identite][:date_dissolution],
      adresse_siege:           adresse_siege,
      code_civilite_dirigeant: nil,
      civilite_dirigeant:      nil,
      code_etat:               nil,
      etat:                    @asso_hash[:identite][:active],
      code_groupement:         nil,
      groupement:              @asso_hash[:identite][:groupement],
      mise_a_jour:             @asso_hash[:identite][:date_modif_rna]
    }
  end

  def adresse_siege
    adresse_siege_complement_1 = @asso_hash[:coordonnees][:adresse_siege][:cplt_1]
    adresse_siege_complement_2 = @asso_hash[:coordonnees][:adresse_siege][:cplt_2]
    adresse_siege_complement_3 = @asso_hash[:coordonnees][:adresse_siege][:cplt_3]

    {
      complement:   [adresse_siege_complement_1, adresse_siege_complement_2, adresse_siege_complement_3].join(' '),
      numero_voie:  @asso_hash[:coordonnees][:adresse_siege][:num_voie],
      type_voie:    @asso_hash[:coordonnees][:adresse_siege][:type_voie],
      libelle_voie: @asso_hash[:coordonnees][:adresse_siege][:voie],
      distribution: @asso_hash[:coordonnees][:adresse_siege][:bp],
      code_insee:   @asso_hash[:coordonnees][:adresse_siege][:code_insee],
      code_postal:  @asso_hash[:coordonnees][:adresse_siege][:cp],
      commune:      @asso_hash[:coordonnees][:adresse_siege][:commune]
    }
  end
end
