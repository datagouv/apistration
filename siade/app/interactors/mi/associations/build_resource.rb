class MI::Associations::BuildResource < BuildResource
  protected

  def resource_attributes
    {
      identite: association[:identite],
      activites: association[:activites],
      siret:,
      adresse_siege:,
    }
  end

  private

  def identite
    association[:identite].each_with_object({}) do |(key, value), hash|
      if key =~ /^date/
        [key, replace_wrong_date_with_nil(value)]
      else
        [key, value]
      end
    end.to_h
  end

  def adresse_siege
    adresse_siege_complement_1 = adresse_siege_raw[:cplt_1]
    adresse_siege_complement_2 = adresse_siege_raw[:cplt_2]
    adresse_siege_complement_3 = adresse_siege_raw[:cplt_3]

    {
      complement: [adresse_siege_complement_1, adresse_siege_complement_2, adresse_siege_complement_3].join(' '),
      numero_voie: adresse_siege_raw[:num_voie],
      type_voie: adresse_siege_raw[:type_voie],
      libelle_voie: adresse_siege_raw[:voie],
      distribution: adresse_siege_raw[:bp],
      code_insee: adresse_siege_raw[:code_insee],
      code_postal: adresse_siege_raw[:cp],
      commune: adresse_siege_raw[:commune]
    }
  end

  def siret
    return unless Siret.new(context.params[:siret_or_rna]).valid?

    context.params[:siret_or_rna]
  end

  def adresse_siege_raw
    @adresse_siege_raw ||= association[:coordonnees][:adresse_siege]
  end

  def association
    @association ||= xml_body_as_hash[:asso]
  end

  def replace_wrong_date_with_nil(date)
    date == '0001-01-01' ? nil : date
  end
end
