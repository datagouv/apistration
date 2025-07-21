module INPI::RNE::ExtraitRNE::Concerns::Constants
  ROLE_MAPPING = {
    '40' => 'PRESIDENT',
    '41' => 'DIRECTEUR GENERAL',
    '53' => 'DIRECTEUR GENERAL',
    '73' => 'PRESIDENT',
    '6000' => 'Président',
    '6001' => 'Président du conseil d\'administration',
    '6002' => 'Président du conseil de surveillance',
    '6100' => 'Directeur Général',
    '6101' => 'Directeur Général Délégué',
    '6200' => 'Gérant',
    '6300' => 'Administrateur',
    '6400' => 'Membre du conseil de surveillance',
    '30' => 'Commissaire aux comptes titulaire',
    '31' => 'Commissaire aux comptes suppléant',
    '67' => 'Associé'
  }.freeze

  FORME_JURIDIQUE_MAPPING = {
    '5498' => 'SARL',
    '5510' => 'Société anonyme à conseil d\'administration',
    '5710' => 'SAS, société par actions simplifiée',
    '5720' => 'SASU, société par actions simplifiée unipersonnelle',
    '6540' => 'EURL',
    '1000' => 'Entreprise individuelle'
  }.freeze

  STATUT_ETABLISSEMENT = {
    '5' => 'actif',
    '6' => 'fermé'
  }.freeze

  ORIGINE_FONDS_MAPPING = {
    '2' => 'Achat',
    '3' => 'Apport',
    '4' => 'Donation'
  }.freeze

  DEFAULT_DEVISE = 'EUR'.freeze
  DEFAULT_PAYS = 'FRANCE'.freeze
  STATUT_FERME = '6'.freeze
  TYPE_PERSONNE_PHYSIQUE = 'P'.freeze
  TYPE_PERSONNE_INDIVIDU = 'INDIVIDU'.freeze
  TYPE_PERSONNE_MORALE = 'MORALE'.freeze
  DIFFUSION_INSEE_OUI = 'O'.freeze
  STATUT_ACTIF = 'actif'.freeze
  TYPE_ETABLISSEMENT_PRINCIPAL = 'Siège et principal'.freeze
  TYPE_ETABLISSEMENT_SECONDAIRE = 'Secondaire'.freeze
  ORIGINE_FONDS_DEFAULT = 'Création'.freeze
  FOURNISSEUR_RCS = 'rcs'.freeze
  FOURNISSEUR_RNM = 'rnm'.freeze
  ENCODING_UTF8 = 'UTF-8'.freeze
  ENCODING_ISO = 'ISO-8859-1'.freeze
  PRODUCTION_HOST = 'entreprise.api.gouv.fr'.freeze
end
