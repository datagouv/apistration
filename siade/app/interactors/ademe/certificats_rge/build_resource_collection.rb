class ADEME::CertificatsRGE::BuildResourceCollection < BuildResourceCollection
  protected

  def items
    json_body['results']
  end

  def items_meta
    {
      count: json_body['results'].count,
      total: json_body['total']
    }
  end

  def resource_attributes(certificat)
    {
      id_ademe: certificat['_id'],
      url: certificat['url_qualification'],
      nom_certificat: certificat['nom_certificat'],
      domaine: certificat['domaine'],
      meta_domaine: certificat['meta_domaine'],
      code_qualification: certificat['code_qualification'],
      nom_qualification: certificat['nom_qualification'],
      organisme: certificat['organisme'],
      date_attribution: certificat['lien_date_debut'],
      date_expiration: certificat['lien_date_fin'],
      archived: certificat['traitement_termine'],
      updated_at: normalized_date(certificat['_updatedAt'])
    }
  end
end
