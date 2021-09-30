class Infogreffe::MandatairesSociaux::BuildResourceCollection < BuildResourceCollection
  protected

  def resource_collection
    initialize_id_information

    infos.try(:css, 'liste_dirigeant dirigeant').try(:reduce, []) do |liste_mandataires, xml_dirigeant|
      @numero_mandataire += 1
      liste_mandataires << mandataire_social(xml_dirigeant)
    end
  end

  private

  def initialize_id_information
    @siren = infos.at_css('num_ident').attributes['siren'].value
    @numero_mandataire = -1
  end

  def infos
    Nokogiri.XML(body)
  end

  def mandataire_social(dirigeant)
    {
      id: "#{@siren}-#{@numero_mandataire}",
      nom: nom(dirigeant),
      prenom: prenom(dirigeant),
      fonction: fonction(dirigeant),
      date_naissance: date_naissance(dirigeant),
      date_naissance_timestamp: date_naissance_timestamp(dirigeant),
      raison_sociale: raison_sociale(dirigeant),
      identifiant: identifiant(dirigeant),
      type: type(dirigeant)
    }
  end

  def nom(dirigeant)
    return unless type(dirigeant) == 'PP'

    dirigeant.css('nom').text.strip
  end

  def prenom(dirigeant)
    return unless type(dirigeant) == 'PP'

    dirigeant.css('prenom').text.strip
  end

  def fonction(dirigeant)
    dirigeant.css('qualite').text.strip
  end

  def date_naissance(dirigeant)
    return unless type(dirigeant) == 'PP' && dirigeant.css('naissance date').present?

    dirigeant.css('naissance date').attribute('dateISO').value
  end

  def date_naissance_timestamp(dirigeant)
    date_naissance(dirigeant).in_time_zone.to_i if date_naissance(dirigeant)
  end

  def raison_sociale(dirigeant)
    return unless type(dirigeant) == 'PM'

    dirigeant.css('denomination').text.strip
  end

  def identifiant(dirigeant)
    return unless type(dirigeant) == 'PM'

    dirigeant.css('pm num_ident').text.strip
  end

  def type(dirigeant)
    dirigeant.attribute('type').value
  end
end
