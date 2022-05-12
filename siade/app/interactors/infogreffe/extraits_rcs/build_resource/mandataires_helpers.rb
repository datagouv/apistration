module Infogreffe::ExtraitsRCS::BuildResource::MandatairesHelpers
  include Infogreffe::Concerns::MandatairesSociaux

  def mandataires_sociaux
    mandataires_sociaux_raw.map do |dirigeant|
      if personne_physique?(dirigeant)
        mandataire_personne_physique(dirigeant)
      else
        mandataire_personne_morale(dirigeant)
      end
    end
  end

  def mandataires_sociaux_raw
    extract_mandataires_sociaux(infos)
  end

  def mandataire_personne_physique(dirigeant)
    {
      type: 'personne_physique',
      nom: nom(dirigeant),
      prenom: prenom(dirigeant),
      fonction: fonction(dirigeant),
      date_naissance: date_naissance_no_day(dirigeant)
    }
  end

  def mandataire_personne_morale(dirigeant)
    {
      type: 'personne_morale',
      numero_identification: identifiant(dirigeant),
      fonction: fonction(dirigeant),
      raison_sociale: raison_sociale(dirigeant)
    }
  end
end
