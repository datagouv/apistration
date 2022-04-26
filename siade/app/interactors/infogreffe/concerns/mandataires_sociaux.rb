module Infogreffe::Concerns::MandatairesSociaux
  def extract_mandataires_sociaux(info_document)
    info_document.try(:css, 'liste_dirigeant dirigeant')
  end

  def pp?(dirigeant)
    type(dirigeant) == 'PP'
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

  def date_naissance_no_day(dirigeant)
    return if date_naissance(dirigeant).blank?

    date_naissance(dirigeant).first(7)
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
    dirigeant.css('greffe').attribute('code')&.value
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
