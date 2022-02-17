class Infogreffe::MandatairesSociaux::BuildResourceCollection < BuildResourceCollection
  def initialize(params)
    super(params)

    @personnes_physiques_count = @personnes_morales_count = 0
  end

  protected

  def items
    Nokogiri
      .XML(body)
      .try(:css, 'liste_dirigeant dirigeant')
  end

  def items_meta
    {
      personnes_physiques_count: @personnes_physiques_count,
      personnes_morales_count: @personnes_morales_count,
      count: @personnes_morales_count + @personnes_physiques_count
    }
  end

  def resource_attributes(dirigeant)
    if type(dirigeant) == 'PP'
      @personnes_physiques_count += 1
      mandataire_social_pp(dirigeant)
    else
      @personnes_morales_count += 1
      mandataire_social_pm(dirigeant)
    end
  end

  private

  def mandataire_social_pp(dirigeant)
    {
      id: [nom(dirigeant), prenom(dirigeant), date_naissance(dirigeant)].join('-'),
      type: 'personne_physique',
      nom: nom(dirigeant),
      prenom: prenom(dirigeant),
      fonction: fonction(dirigeant),
      date_naissance: date_naissance(dirigeant),
      date_naissance_timestamp: date_naissance_timestamp(dirigeant),
      lieu_naissance: lieu_naissance(dirigeant),
      pays_naissance: pays_naissance(dirigeant),
      code_pays_naissance: code_pays_naissance(dirigeant),
      nationalite: nationalite(dirigeant),
      code_nationalite: code_nationalite(dirigeant)
    }
  end

  def mandataire_social_pm(dirigeant)
    {
      id: identifiant(dirigeant),
      type: 'personne_morale',
      fonction: fonction(dirigeant),
      raison_sociale: raison_sociale(dirigeant),
      code_greffe: code_greffe(dirigeant),
      libelle_greffe: libelle_greffe(dirigeant)
    }
  end

  def nom(dirigeant)
    dirigeant.css('nom').text.strip
  end

  def prenom(dirigeant)
    dirigeant.css('prenom').text.strip
  end

  def fonction(dirigeant)
    dirigeant.css('qualite').text.strip
  end

  def date_naissance(dirigeant)
    return if dirigeant.css('naissance date').blank?

    dirigeant.css('naissance date').attribute('dateISO').value
  end

  def lieu_naissance(dirigeant)
    dirigeant.css('naissance lieu').text.strip
  end

  def pays_naissance(dirigeant)
    dirigeant.css('naissance').attribute('pays').value
  end

  def code_pays_naissance(dirigeant)
    dirigeant.css('naissance').attribute('codePays').value
  end

  def nationalite(dirigeant)
    dirigeant.css('pp').attribute('nationalite').value
  end

  def code_nationalite(dirigeant)
    dirigeant.css('pp').attribute('codeNationalite').value
  end

  def date_naissance_timestamp(dirigeant)
    date_naissance(dirigeant).in_time_zone.to_i if date_naissance(dirigeant)
  end

  def raison_sociale(dirigeant)
    dirigeant.css('denomination').text.strip
  end

  def code_greffe(dirigeant)
    dirigeant.css('greffe').attribute('code').value
  end

  def libelle_greffe(dirigeant)
    dirigeant.css('greffe').text.strip
  end

  def identifiant(dirigeant)
    dirigeant.css('pm num_ident').text.strip
  end

  def type(dirigeant)
    dirigeant.attribute('type').value
  end
end
