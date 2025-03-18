class CNAV::QuotientFamilialV2::BuildResource < BuildResource
  protected

  def resource_attributes
    {
      quotient_familial:,
      allocataires: build_persons_attributes(json_body['allocataires']),
      enfants: build_persons_attributes(json_body['enfants']),
      adresse: build_address_attributes(json_body['adresse'])
    }
  end

  def quotient_familial
    {
      fournisseur:,
      valeur: string_value_or_nil(json_body['quotientFamilial']),
      annee: annee_demande.to_i,
      mois: mois_demande.to_i,
      annee_calcul:,
      mois_calcul:
    }
  end

  def build_address_attributes(attributes)
    {
      destinataire: string_value_or_nil(attributes['identite']),
      complement_information: string_value_or_nil(attributes['complementInformation']),
      complement_information_geographique: string_value_or_nil(attributes['complementInformationGeo']),
      numero_libelle_voie: string_value_or_nil(attributes['numeroLibelleVoie']),
      lieu_dit: string_value_or_nil(attributes['lieuDit']),
      code_postal_ville: string_value_or_nil(attributes['codePostalVille']),
      pays: string_value_or_nil(attributes['pays'])
    }
  end

  def build_persons_attributes(persons)
    return [] if persons.nil?

    persons.map do |person|
      build_person_attributes(person)
    end
  end

  def build_person_attributes(attributes)
    year, month, day = date_naissance_or_default(attributes['dateNaissance']).split('-')
    {
      nom_naissance: string_value_or_nil(attributes['nomNaissance']),
      nom_usage: string_value_or_nil(attributes['nomUsage']),
      prenoms: string_value_or_nil(attributes['listePrenoms']),
      annee_date_de_naissance: format_date_part(year),
      mois_date_de_naissance: format_date_part(month),
      jour_date_de_naissance: format_date_part(day),
      date_naissance: date_naissance_or_default(attributes['dateNaissance']),
      sexe: string_value_or_nil(attributes['genre'])
    }
  end

  def date_naissance_or_default(datum)
    return '0000-00-00' if datum.blank?

    datum
  end

  def string_value_or_nil(datum)
    return if datum.blank?

    datum
  end

  def format_date_part(part)
    return nil if part.to_i.zero?

    part
  end

  def annee_calcul
    return Time.zone.now.year if msa?

    json_body['annee']
  end

  def mois_calcul
    return Time.zone.now.month if msa?

    json_body['mois']
  end

  def msa?
    response['X-APISECU-FD'] == CNAV::QuotientFamilialV2::REGIME_CODE_MSA
  end

  def cnav?
    response['X-APISECU-FD'] == CNAV::QuotientFamilialV2::REGIME_CODE_CNAF
  end

  def fournisseur
    raise 'Fournisseur not found' if response['X-APISECU-FD'].nil?

    CNAV::QuotientFamilialV2::REGIME_CODE_LABEL[response['X-APISECU-FD']]
  end

  def mois_demande
    Kernel.format('%<month>02d', month: context.params[:mois].presence&.to_i || Time.zone.today.month)
  end

  def annee_demande
    context.params[:annee].presence || Time.zone.today.year
  end
end
