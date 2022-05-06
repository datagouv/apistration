class Infogreffe::ExtraitsRCS::BuildResource < BuildResource
  include Infogreffe::Concerns::MandatairesSociaux
  include Infogreffe::ExtraitsRCS::BuildResource::AdresseHelpers

  protected

  def resource_attributes
    {
      siren: context.params[:siren],
      date_extrait: dossier['date_extrait'],
      date_immatriculation: dossier['dateISO_immat'],
      mandataires_sociaux:,
      observations:,
      denomination: infos.css('pm denomination').text,
      nom_commercial:,
      forme_juridique: infos.css('pm').attr('forme_juridique').to_s,
      code_forme_juridique: infos.css('pm').attr('codeFormeJuridique').to_s,
      adresse_siege: build_adresse(reference_adresse_siege),
      etablissement_principal:,
      date_cloture_exercice_comptable: dossier.css('pm date_cloture').attr('dateISO').to_s,
      date_fin_de_vie: infos.css('pm duree_ste valeur_duree').attr('dateISO').to_s,
      capital:,
      greffe: dossier.css('entreprise greffe').text,
      code_greffe: dossier.css('entreprise greffe').attr('code').to_s
    }
  end

  private

  def infos
    @infos ||= Nokogiri.XML(body)
  end

  def mandataires_sociaux
    mandataires_sociaux_raw.map do |dirigeant|
      if personne_physique?(dirigeant)
        personne_physique_payload(dirigeant)
      else
        personne_morale_payload(dirigeant)
      end
    end
  end

  def mandataires_sociaux_raw
    extract_mandataires_sociaux(infos)
  end

  def personne_physique_payload(dirigeant)
    {
      type: 'personne_physique',
      nom: nom(dirigeant),
      prenom: prenom(dirigeant),
      fonction: fonction(dirigeant),
      date_naissance: date_naissance_no_day(dirigeant)
    }
  end

  def personne_morale_payload(dirigeant)
    {
      type: 'personne_morale',
      numero_identification: identifiant(dirigeant),
      fonction: fonction(dirigeant),
      raison_sociale: raison_sociale(dirigeant)
    }
  end

  def etablissements_raw
    infos.css('etablissement')
  end

  def etablissement_principal_raw
    etablissements_raw.select { |etablissement| etablissement.attr('type').to_s == '1' }.first
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

  def nom_commercial
    nom_commercial_from_etablissement_principal || nom_commercial_any_etablissement
  end

  def nom_commercial_from_etablissement_principal
    etablissement_principal_raw&.css('nom_commercial')&.text
  end

  def nom_commercial_any_etablissement
    etablissements_raw&.css('nom_commercial')&.text
  end

  def etablissement_principal
    {
      adresse: build_adresse(reference_adresse_etablissement_principal),
      activite: etablissement_principal_raw.css('activite').text,
      origine_fonds: etablissement_principal_raw.css('origine_fonds').text,
      mode_exploitation: etablissement_principal_raw.css('mode_exploit').text,
      code_ape: etablissement_principal_raw.css('codeAPE').text
    }
  end

  def capital
    {
      montant: cast_montant_as_float(infos.css('capital montant').text),
      devise: infos.css('capital montant devise').to_s,
      code_devise: infos.css('capital montant codeDevise').to_s
    }
  end

  def cast_montant_as_float(montant)
    montant.delete(' ').split(',').join('.').to_f
  end
end
