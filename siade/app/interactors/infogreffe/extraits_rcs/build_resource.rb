class Infogreffe::ExtraitsRCS::BuildResource < BuildResource
  include Infogreffe::ExtraitsRCS::BuildResource::AdresseHelpers
  include Infogreffe::ExtraitsRCS::BuildResource::MandatairesHelpers

  protected

  def resource_attributes
    {
      siren: context.params[:siren],
      date_extrait: dossier['date_extrait'],
      date_immatriculation: dossier['dateISO_immat'],
      mandataires_sociaux:,
      observations:,
      nom_commercial:,
      adresse_siege: build_adresse(reference_adresse_siege),
      etablissement_principal:,
      capital:,
      greffe:,
      personne_morale:,
      personne_physique:
    }
  end

  private

  def infos
    @infos ||= Nokogiri.XML(body)
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
      activite: extract_etablissement_text_attribute('activite'),
      origine_fonds: extract_etablissement_text_attribute('origine_fonds'),
      mode_exploitation: extract_etablissement_text_attribute('mode_exploit'),
      code_ape: extract_etablissement_text_attribute('codeAPE')
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

  def greffe
    {
      valeur: dossier.css('entreprise greffe').text,
      code: dossier.css('entreprise greffe').attr('code').to_s
    }
  end

  def personne_morale
    {
      forme_juridique: forme_juridique_personne_morale,
      denomination: dossier.css('entreprise pm denomination').text,
      date_cloture_exercice_comptable: dossier.css('entreprise pm date_cloture').attr('dateISO').to_s,
      date_fin_de_vie: dossier.css('entreprise pm duree_ste valeur_duree').attr('dateISO').to_s
    }
  end

  def forme_juridique_personne_morale
    {
      valeur: dossier.css('entreprise pm').attr('forme_juridique').to_s,
      code: dossier.css('entreprise pm').attr('codeFormeJuridique').to_s
    }
  end

  def personne_physique
    {
      adresse: build_adresse(reference_adresse_personne_physique),
      nationalite: nationalite_personne_physique,
      nom: dossier.css('entreprise pp nom').text,
      prenom: dossier.css('entreprise pp prenom').text,
      naissance: naissance_personne_physique
    }
  end

  def nationalite_personne_physique
    {
      valeur: dossier.css('entreprise pp').attr('nationalite').to_s,
      code: dossier.css('entreprise pp').attr('codeNationalite').to_s
    }
  end

  def naissance_personne_physique
    {
      pays: pays_naissance_personne_physique,
      date: dossier.css('entreprise pp naissance date').attr('dateISO').to_s,
      lieu: dossier.css('entreprise pp naissance lieu').text
    }
  end

  def pays_naissance_personne_physique
    {
      valeur: dossier.css('entreprise pp naissance').attr('pays').to_s,
      code: dossier.css('entreprise pp naissance').attr('codePays').to_s
    }
  end

  def extract_etablissement_text_attribute(attribute)
    etablissement_principal_raw&.css(attribute)&.text
  end
end
