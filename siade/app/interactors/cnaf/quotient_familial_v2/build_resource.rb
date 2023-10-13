class CNAF::QuotientFamilialV2::BuildResource < BuildResource
  protected

  def resource_attributes
    {
      allocataires: build_persons_attributes(json_body['allocataires']),
      enfants: build_persons_attributes(json_body['enfants']),
      adresse: build_address_attributes(json_body['adresse']),
      quotientFamilial: string_value_or_nil(json_body['quotientFamilial']),
      annee: context['params'][:annee].to_i,
      mois: context['params'][:mois].to_i,
      regime:,
      annee_calcul:,
      mois_calcul:
    }
  end

  def build_address_attributes(attributes)
    {
      identite: string_value_or_nil(attributes['identite']),
      complementInformation: string_value_or_nil(attributes['complementInformation']),
      complementInformationGeographique: string_value_or_nil(attributes['complementInformationGeo']),
      numeroLibelleVoie: string_value_or_nil(attributes['numeroLibelleVoie']),
      lieuDit: string_value_or_nil(attributes['lieuDit']),
      codePostalVille: string_value_or_nil(attributes['codePostalVille']),
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
      nomNaissance: string_value_or_nil(attributes['nomNaissance']),
      nomUsuel: string_value_or_nil(attributes['nomUsage']),
      prenoms: string_value_or_nil(attributes['listePrenoms']),
      anneeDateDeNaissance: format_date_part(year),
      moisDateDeNaissance: format_date_part(month),
      jourDateDeNaissance: format_date_part(day),
      sexe: string_value_or_nil(attributes['genre'])
    }
  end

  def date_naissance_or_default(datum)
    '0000-00-00' if datum.blank?

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
    response['X-APISECU-FD'] == CNAF::QuotientFamilialV2::REGIME_CODE_MSA
  end

  def cnaf?
    response['X-APISECU-FD'] == CNAF::QuotienFamilialV2::REGIME_CODE_CNAF
  end

  def regime
    raise 'Regime not found' if response['X-APISECU-FD'].nil?

    CNAF::QuotientFamilialV2::REGIME_CODE_LABEL[response['X-APISECU-FD']] unless response['X-APISECU-FD'].nil?
  end
end
