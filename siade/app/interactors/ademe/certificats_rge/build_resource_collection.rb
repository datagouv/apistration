class ADEME::CertificatsRGE::BuildResourceCollection < BuildResourceCollection
  protected

  def items
    json_body['results']
  end

  def items_context
    {
      total: json_body['total']
    }
  end

  def resource_attributes(certificat)
    {
      url: certificat['url_qualification'],
      nom_certificat: certificat['nom_certificat'],
      domaine: certificat['domaine'],
      meta_domaine: certificat['meta_domaine'],
      qualification: qualification(certificat),
      organisme: certificat['organisme'],
      date_attribution: certificat['lien_date_debut'],
      date_expiration: certificat['lien_date_fin'],
      meta: meta(certificat)
    }
  end

  private

  def qualification(certificat)
    {
      code: certificat['code_qualification'],
      nom: certificat['nom_qualification']
    }
  end

  def meta(certificat)
    {
      internal_id: certificat['_id'],
      archived: certificat['traitement_termine'],
      updated_at: normalized_date(certificat['_updatedAt'])
    }
  end
end
