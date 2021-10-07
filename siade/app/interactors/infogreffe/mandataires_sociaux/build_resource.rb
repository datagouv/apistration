class Infogreffe::MandatairesSociaux::BuildResource < BuildResource
  protected

  def resource_attributes
    liste_pp = []
    liste_pm = []

    infos.try(:css, 'liste_dirigeant dirigeant')&.each do |dirigeant|
      liste_pp << mandataire_social_pp(dirigeant) if type(dirigeant) == 'PP'
      liste_pm << mandataire_social_pm(dirigeant) if type(dirigeant) == 'PM'
    end

    {
      id: infos.at_css('num_ident').attributes['siren'].value,
      pp: liste_pp,
      pm: liste_pm
    }
  end

  private

  def infos
    @infos ||= Nokogiri.XML(body)
  end

  def mandataire_social_pp(dirigeant)
    {
      nom: nom(dirigeant),
      prenom: prenom(dirigeant),
      fonction: fonction(dirigeant),
      date_naissance: date_naissance(dirigeant),
      date_naissance_timestamp: date_naissance_timestamp(dirigeant)
    }
  end

  def mandataire_social_pm(dirigeant)
    {
      fonction: fonction(dirigeant),
      raison_sociale: raison_sociale(dirigeant),
      identifiant: identifiant(dirigeant)
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

  def date_naissance_timestamp(dirigeant)
    date_naissance(dirigeant).in_time_zone.to_i if date_naissance(dirigeant)
  end

  def raison_sociale(dirigeant)
    dirigeant.css('denomination').text.strip
  end

  def identifiant(dirigeant)
    dirigeant.css('pm num_ident').text.strip
  end

  def type(dirigeant)
    dirigeant.attribute('type').value
  end
end
