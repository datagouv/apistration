class UnprocessableEntityError < ApplicationError
  attr_reader :field

  def initialize(field, meta: {})
    @field = field.to_sym
    @meta = meta
  end

  def meta
    @meta || {}
  end

  # rubocop:disable Metrics/MethodLength
  def code
    {
      siren: '00301',
      siret: '00302',
      siret_or_rna: '00303',
      siren_or_rna: '00333',
      siret_or_eori: '00304',
      month: '00305',
      code_insee_commune: '00306',
      siren_or_siret_or_rna: '00330',
      uuid: '00314',
      # DGFIP entreprise
      year: '00307',
      dgfip_year: '00315',
      user_id: '00308',
      request_name: '00309',
      siren_is: '00311',
      siren_tva: '00312',
      # ACOSS
      attestation_kind: '00310',
      # ADEME
      limit: '00313',
      # CNAF
      postal_code: '00351',
      cnaf_beneficiary_number: '00352',
      # CNAV
      annee: '00353',
      mois: '00354',
      sngi: '00355',
      # MESRI / MEN / CNOUS
      ine: '00360',
      family_name: '00361',
      first_name: '00362',
      first_names: '00367',
      birth_date: '00363',
      gender: '00364',
      birth_place: '00365',
      civility: '00366',
      # DGFIP usager
      tax_number: '00370',
      tax_notice_number: '00371',
      # France Travail / SDH
      identifiant: '00380',
      # GIP-MDS
      gip_mds_depth: '00390',
      gip_mds_too_many_individus: '00391',
      insee_country_code: '00400',
      request_id: '00401',
      # MEN
      code_etablissement: '00410',
      annee_scolaire: '00411',
      degre_etablissement: '00412',
      perimetre: '00413',
      perimetre_valeurs: '00414',
      codes_cog_insee_communes: '00415',
      codes_bcn_men_departements: '00416',
      codes_bcn_men_regions: '00417',
      identifiants_siren_intercommunalites: '00418',
      # ANTS - ExtraitImmatriculationVehicule
      immatriculation: '00430',
      # INPI - RNE
      document_id: '00501',
      # CIVILITY API PART v3
      nom_naissance: '00420',
      prenoms: '00421',
      annee_date_naissance: '00422',
      mois_date_naissance: '00423',
      jour_date_naissance: '00424',
      date_naissance: '00425',
      code_cog_insee_commune_naissance: '00426',
      sexe_etat_civil: '00427',
      code_cog_insee_departement_naissance: '00428'
    }.fetch(field) do
      raise KeyError, "#{field} is not a valid field name"
    end
  end
  # rubocop:enable Metrics/MethodLength

  def kind
    :wrong_parameter
  end
end
