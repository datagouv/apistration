class UnprocessableEntityError < ApplicationError
  def self.build_example(field:, **)
    new(field)
  end

  attr_reader :field

  def initialize(field, meta: {})
    @field = field.to_sym
    @meta = meta
  end

  def meta
    @meta || {}
  end

  # rubocop:disable-next Metrics/MethodLength
  def code
    {
      siren: '00301',
      siret: '00302',
      siret_or_rna: '00303',
      siren_or_rna: '00333',
      siret_or_eori: '00304',
      month: '00305',
      nom_commune_naissance: '00317',
      siren_or_siret_or_rna: '00330',
      siren_or_siret_or_rnf: '00331',
      uuid: '00314',
      token_id: '00316',
      # DGFIP entreprise
      year: '00307',
      dgfip_year: '00315',
      user_id: '00308',
      # ACOSS
      # ADEME
      limit: '00313',
      # CNAF
      postal_code: '00351',
      # CNAV
      annee_cnav: '00356',
      mois: '00354',
      # MESRI / MEN / CNOUS
      ine: '00360',
      first_names: '00367',
      birth_date: '00363',
      birth_place: '00365',
      campaign_year: '00368',
      # DGFIP usager
      # France Travail / SDH
      identifiant: '00380',
      # GIP-MDS
      gip_mds_depth: '00390',
      insee_country_code: '00400',
      # MEN
      code_etablissement: '00410',
      annee_scolaire: '00411',
      degre_etablissement: '00412',
      perimetre: '00413',
      perimetre_valeurs: '00414',
      codes_bcn_departements: '00416',
      codes_bcn_regions: '00417',
      critere_recherche_manquant: '00415',
      code_etablissement_et_perimetre: '00419',
      # ANTS - ExtraitImmatriculationVehicule
      immatriculation: '00430',
      # INPI - RNE
      document_id: '00318',
      # CIVILITY API PART v3
      nom_naissance: '00420',
      prenoms: '00421',
      annee_date_naissance: '00422',
      mois_date_naissance: '00423',
      jour_date_naissance: '00424',
      date_naissance: '00425',
      sexe_etat_civil: '00427',
      code_cog_insee_departement_naissance: '00428'
    }.fetch(field) do
      raise KeyError, "#{field} is not a valid field name"
    end
  end

  def kind
    :wrong_parameter
  end
end
