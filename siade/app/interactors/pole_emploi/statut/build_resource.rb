class PoleEmploi::Statut::BuildResource < BuildResource
  def resource_attributes
    {
      identifiant:,
      adresse: address_attributes
    }.merge(identity_attributes)
      .merge(contact_attributes)
      .merge(inscription_attributes)
  end

  private

  def identifiant
    context.params[:identifiant_pole_emploi]
  end

  def identity_attributes
    build_hash_from_attributes(
      json_body,
      %i[
        civilite
        nom
        nomUsage
        prenom
        sexe
        dateNaissance
      ]
    )
  end

  def contact_attributes
    build_hash_from_attributes(
      json_body,
      %i[
        email
        telephone
        telephone2
      ]
    )
  end

  def inscription_attributes
    build_hash_from_attributes(
      json_body,
      %i[
        dateInscription
        dateCessationInscription
        codeCertificationCNAV
      ]
    ).merge(
      codeCategorieInscription: string_value_or_nil(json_body['categorieInscription']),
      libelleCategorieInscription: string_value_or_nil(json_body['libellecategorieInscription'])
    )
  end

  def address_attributes
    build_hash_from_attributes(
      json_body['adresse'],
      %i[
        INSEECommune
        codePostal
        ligneComplementAdresse
        ligneComplementDestinataire
        ligneComplementDistribution
        ligneNom
        ligneVoie
        localite
      ]
    )
  end

  def build_hash_from_attributes(data, attributes)
    attributes.index_with do |attribute|
      string_value_or_nil(data[attribute.to_s])
    end
  end

  def string_value_or_nil(datum)
    return if datum.blank?

    datum
  end
end
