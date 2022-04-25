class ADEME::CertificatsRGE::BuildResource < BuildResource
  protected

  def resource_attributes
    {
      entreprise:,
      certificats:
    }
  end

  private

  def results
    json_body['results']
  end

  def body_first_record
    results.first
  end

  def meta
    {
      count: json_body['total']
    }
  end

  # rubocop:disable Metrics/AbcSize
  def entreprise
    {
      siret: body_first_record['siret'],
      nom: body_first_record['nom_entreprise'],
      adresse: body_first_record['adresse'],
      code_postal: body_first_record['code_postal'],
      commune: body_first_record['commune'],
      latitude: body_first_record['latitude'],
      longitude: body_first_record['longitude'],
      telephone: body_first_record['telephone'],
      site_internet: body_first_record['site_internet'],
      email: body_first_record['email'],
      particuliers: body_first_record['particulier']
    }
  end
  # rubocop:enable Metrics/AbcSize

  def certificats
    results.map { |record| certificat_attributes(record) }
  end

  def certificat_attributes(certificat)
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
      updated_at: normalized_date(certificat['_updatedAt'])
    }
  end
end
