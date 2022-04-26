class Infogreffe::ExtraitsRCS::BuildResource < BuildResource
  include Infogreffe::Concerns::MandatairesSociaux

  protected

  def resource_attributes
    {
      id: context.params[:siren],
      date_extrait: dossier['date_extrait'],
      date_immatriculation: dossier['dateISO_immat'],
      mandataires_sociaux:,
      observations:
    }
  end

  private

  def infos
    @infos ||= Nokogiri.XML(body)
  end

  def mandataires_sociaux
    mandataires_sociaux_raw.map do |dirigeant|
      if pp?(dirigeant)
        mandataire_social_pp(dirigeant)
      else
        mandataire_social_pm(dirigeant)
      end
    end
  end

  def mandataires_sociaux_raw
    extract_mandataires_sociaux(infos)
  end

  def mandataire_social_pp(dirigeant)
    {
      type: 'personne_physique',
      nom: nom(dirigeant),
      prenom: prenom(dirigeant),
      fonction: fonction(dirigeant),
      date_naissance: date_naissance_no_day(dirigeant)
    }
  end

  def mandataire_social_pm(dirigeant)
    {
      type: 'personne_morale',
      numero_identification: identifiant(dirigeant),
      fonction: fonction(dirigeant),
      raison_sociale: raison_sociale(dirigeant)
    }
  end

  def dossier
    infos.css('dossier').first
  end

  def observations
    infos.css('liste_observations observation').map do |observation|
      {
        numero: observation.attribute('numero').value,
        libelle: observation.css('libelle').text.strip,
        date: observation.attribute('dateISO').value
      }
    end
  end
end
