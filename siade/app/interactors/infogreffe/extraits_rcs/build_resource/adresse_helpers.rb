module Infogreffe::ExtraitsRCS::BuildResource::AdresseHelpers
  SCHEMA_14_FIELDS = {
    'nompostal' => 'ligne1',
    'voie' => 'ligne2',
    'localite' => 'ligne3'
  }.freeze

  def build_adresse(reference_adresse)
    adresse = adresse_from_reference(reference_adresse)

    {
      nom_postal: extract_from_adresse(adresse, 'nompostal'),
      numero: extract_from_adresse(adresse, 'numero'),
      type: extract_from_adresse(adresse, 'type'),
      voie: extract_from_adresse(adresse, 'voie'),
      ligne_1: extract_from_adresse(adresse, 'ligne1'),
      ligne_2: extract_from_adresse(adresse, 'ligne2'),
      localite: extract_from_adresse(adresse, 'localite'),
      code_postal: extract_from_adresse(adresse, 'code_postal'),
      bureau_distributeur: extract_from_adresse(adresse, 'bureau_distributeur'),
      pays: extract_from_adresse(adresse, 'pays')
    }
  end

  def extract_from_adresse(adresse, target)
    child = adresse&.at_css("> #{target}")
    return child.text if child
    return '' unless SCHEMA_14_FIELDS.key?(target) && schema_14_adresse?(adresse)

    child_text(adresse, SCHEMA_14_FIELDS[target])
  end

  def schema_14_adresse?(adresse)
    !adresse&.at_css('> ligne3').nil?
  end

  def child_text(node, name)
    node&.at_css("> #{name}")&.text || ''
  end

  def adresse_from_reference(reference)
    infos.css('adresse').find { |adresse| adresse.attr('id') == reference }
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
