class CNAV::ParticipationFamilialeEAJE::BuildAttestationProof < APIParticulier::BuildAttestationProof
  SEXE_LABELS = { 'M' => 'Masculin', 'F' => 'Féminin' }.freeze

  IDENTITE = [
    ['nom_naissance', 'Nom de naissance'],
    ['nom_usage', "Nom d'usage"],
    ['prenoms', 'Prénoms'],
    ['date_naissance', 'Date de naissance'],
    ['sexe', 'Sexe', ->(sexe) { SEXE_LABELS.fetch(sexe, sexe) }],
    ['code_cog_insee_commune_naissance', 'Code INSEE de la commune de naissance']
  ].freeze

  IDENTITE_MINIMISEE = [
    ['nom_naissance', 'Nom de naissance', ->(nom) { "#{nom.first(3)}•••" }],
    ['date_naissance', 'Date de naissance', ->(date) { "#{date[5, 2]}/#{date[0, 4]}" }]
  ].freeze

  ADRESSE = [
    ['destinataire', 'Destinataire'],
    ['complement_information', "Complément d'information"],
    ['complement_information_geographique', "Complément d'information géographique"],
    ['numero_libelle_voie', 'Numéro et libellé de voie'],
    ['lieu_dit', 'Lieu-dit'],
    ['code_postal_ville', 'Code postal / Ville'],
    ['pays', 'Pays']
  ].freeze

  PARAMETRES = [
    ['nombre_enfants_a_charge', "Nombre d'enfants à charge"],
    ['nombre_enfants_beneficiaire_aeeh', "Nombre d'enfants bénéficiaires de l'AEEH"]
  ].freeze

  BASE_RESSOURCES = [
    ['valeur', 'Base de ressources annuelles', ->(valeur) { { 'highlight' => display(valeur) } }],
    ['annee_calcul', 'Année de calcul']
  ].freeze

  protected

  def document
    'participation_familiale_eaje'
  end

  def title
    'ATTESTATION DE PARTICIPATION FAMILIALE (EAJE)'
  end

  def source
    'CNAF'
  end

  def verification_sections
    [
      allocataires_section(IDENTITE_MINIMISEE),
      section('Enfants', 'cnav_participation_familiale_eaje_enfants') do
        [[["Nombre d'enfants", data['enfants'].size.to_s]]] if data['enfants'].present?
      end,
      parametres_section
    ].compact
  end

  def attestation_sections
    [
      allocataires_section(IDENTITE),
      section('Enfants', 'cnav_participation_familiale_eaje_enfants') do
        data['enfants']&.map { |enfant| rows(IDENTITE, enfant) }
      end,
      section('Adresse', 'cnav_participation_familiale_eaje_adresse') { [rows(ADRESSE, data['adresse'] || {})] },
      parametres_section
    ].compact
  end

  private

  def allocataires_section(table)
    section('Allocataires', 'cnav_participation_familiale_eaje_allocataires') do
      data['allocataires']&.map { |allocataire| rows(table, allocataire) }
    end
  end

  def parametres_section
    @parametres_section ||=
      section('Paramètres de calcul de la participation familiale', 'cnav_participation_familiale_eaje_parametres_calcul') do
        parametres = data['parametres_calcul_participation_familiale'] || {}

        [rows(PARAMETRES, parametres) + rows(BASE_RESSOURCES, parametres['base_ressources_annuelles'] || {})]
      end
  end
end
