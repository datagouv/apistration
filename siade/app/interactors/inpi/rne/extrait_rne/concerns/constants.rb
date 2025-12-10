module INPI::RNE::ExtraitRNE::Concerns::Constants
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
