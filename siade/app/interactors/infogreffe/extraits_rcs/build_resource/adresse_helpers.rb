module Infogreffe::ExtraitsRCS::BuildResource::AdresseHelpers
  def build_adresse(reference_adresse)
    {
      nom_postal: extract_from_adresse(reference_adresse, 'nompostal'),
      numero: extract_from_adresse(reference_adresse, 'numero'),
      type: extract_from_adresse(reference_adresse, 'type'),
      voie: extract_from_adresse(reference_adresse, 'voie'),
      ligne_1: extract_from_adresse(reference_adresse, 'ligne1'),
      ligne_2: extract_from_adresse(reference_adresse, 'ligne2'),
      localite: extract_from_adresse(reference_adresse, 'localite'),
      code_postal: extract_from_adresse(reference_adresse, 'code_postal'),
      bureau_distributeur: extract_from_adresse(reference_adresse, 'bureau_distributeur'),
      pays: extract_from_adresse(reference_adresse, 'pays')
    }
  end

  def extract_from_adresse(reference_adresse, target)
    adresse_raw_from_reference(reference_adresse)&.select { |info| info.name == target }&.first&.text || ''
  end

  def adresse_raw_from_reference(reference)
    infos.css('adresse').select { |adresse| adresse&.attr('id') == reference }.first&.children
  end

  def reference_adresse_siege
    dossier.css('entreprise').attr('id_adr_siege').to_s
  end

  def reference_adresse_etablissement_principal
    etablissement_principal_raw&.attr('adresse')&.to_s
  end

  def reference_adresse_personne_physique
    dossier.css('entreprise pp').attr('adresse').to_s
  end
end
