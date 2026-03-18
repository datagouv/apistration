class SIADE::V2::Adapters::AttestationsFiscalesDGFIP
  include ActiveModel::Model

  attr_accessor :user_id, :siren,
    :groupe_is, :groupe_tva, :membre_is, :membre_tva,
    :entreprise_is,  :etablissement_is,
    :entreprise_tva, :etablissement_tva,
    :code_postal_is,  :raison_sociale_is,  :adresse_is,  :ville_is,  :complement_is,
    :code_postal_tva, :raison_sociale_tva, :adresse_tva, :ville_tva, :complement_tva

  validates_format_of :user_id, with: /\A([^@\s]+_at_(?:[-a-z0-9]+.)+[a-z]{2,}.\w+)|(\A[a-f0-9_]+)\z/i, message: "Le user_id n'est pas correctement formatté"

  validates_format_of :membre_is  , with: /MERE|FILLE/ , if: :groupe_is?
  validates_format_of :membre_tva , with: /MERE|FILLE/ , if: :groupe_tva?

  validates_format_of :groupe_tva , with: /OUI|NON/
  validates_format_of :groupe_is  , with: /OUI|NON/, message: "Groupe IS doit valoir OUI ou NON"

  validates :user_id    , presence: true

  validates :groupe_is  , presence: true
  validates :groupe_tva , presence: true

  validates_length_of :code_postal_is    , maximum: 5
  validates_length_of :ville_is          , maximum: 27
  validates_length_of :complement_is     , maximum: 27
  validates_length_of :raison_sociale_is , maximum: 54
  validates_length_of :adresse_is        , maximum: 54

  validates_length_of :code_postal_tva    , maximum: 5
  validates_length_of :ville_tva          , maximum: 27
  validates_length_of :complement_tva     , maximum: 27
  validates_length_of :raison_sociale_tva , maximum: 54
  validates_length_of :adresse_tva        , maximum: 54

  validate :no_successor_attributes_set_for_groupe_tva_if_false
  validate :no_successor_attributes_set_for_groupe_is_if_false

  validate :no_successor_attributes_set_for_membre_is_if_mere
  validate :no_successor_attributes_set_for_membre_tva_if_mere

  validate :must_have_successor_attributes_set_for_membre_tva_if_fille
  validate :must_have_successor_attributes_set_for_membre_is_if_fille

  def initialize(params)
    self.user_id           = params[:user_id]
    self.siren             = params[:siren]
    self.entreprise_is     = params[:entreprise_is]
    self.entreprise_tva    = params[:entreprise_tva]
    self.etablissement_is  = params[:etablissement_is]
    self.etablissement_tva = params[:etablissement_tva]

    set_groupe_is
    set_membre_is
    set_address_is_when_fille

    set_groupe_tva
    set_membre_tva
    set_address_tva_when_fille
  end

  def to_hash
    to_raw_hash.delete_if { |_k, v| v.blank? }
  end

  private

  def to_raw_hash
    {
      userId:            user_id,
      groupeIS:          groupe_is,
      membreIS:          membre_is,
      code_postalIS:     code_postal_is,
      raison_socialeIS:  raison_sociale_is,
      adresseIS:         adresse_is,
      villeIS:           ville_is,
      complementIS:      complement_is,
      groupeTVA:         groupe_tva,
      membreTVA:         membre_tva,
      code_postalTVA:    code_postal_tva,
      raison_socialeTVA: raison_sociale_tva,
      adresseTVA:        adresse_tva,
      villeTVA:          ville_tva,
      complementTVA:     complement_tva,
      siren:             siren
    }
  end

  def groupe_tva?
    groupe_tva == 'OUI'
  end

  def groupe_is?
    groupe_is == 'OUI'
  end

  def set_groupe_is
    if not entreprise_is.nil?
      self.groupe_is = (!!entreprise_is.siren && Siren.new(entreprise_is.siren).valid?) ? 'OUI' : 'NON'
    else
      self.groupe_is = 'NON'
    end
  end

  def set_groupe_tva
    if not entreprise_tva.nil?
      self.groupe_tva = (!!entreprise_tva.siren && Siren.new(entreprise_tva.siren).valid?) ? 'OUI' : 'NON'
    else
      self.groupe_tva = 'NON'
    end
  end

  def set_membre_is
    if groupe_is == 'OUI'
      if entreprise_is.siren == siren
        self.membre_is = 'MERE'
      else
        self.membre_is = 'FILLE'
      end
    end
  end

  def set_membre_tva
    if groupe_tva == 'OUI'
      if entreprise_tva.siren == siren
        self.membre_tva = 'MERE'
      else
        self.membre_tva = 'FILLE'
      end
    end
  end

  def set_address_is_when_fille
    if membre_is == 'FILLE'
      self.raison_sociale_is = entreprise_is.raison_sociale
      self.code_postal_is    = etablissement_is.adresse[:code_postal]
      self.adresse_is        = adresse_l1_is
      self.ville_is          = adresse_localite_is
      self.complement_is     = etablissement_is.adresse[:complement_adresse]
    end
  end

  def adresse_l1_is
    [
      etablissement_is.adresse[:numero_voie],
      etablissement_is.adresse[:indice_repetition],
      etablissement_is.adresse[:type_voie],
      etablissement_is.adresse[:libelle_voie]
    ]
      .compact
      .join(' ')
  end

  def adresse_localite_is
    etablissement_is.adresse[:libelle_commune] || etablissement_is.adresse[:libelle_commune_etranger]
  end

  def set_address_tva_when_fille
    if membre_tva == 'FILLE'
      self.raison_sociale_tva = entreprise_tva.raison_sociale
      self.code_postal_tva    = etablissement_tva.adresse[:code_postal]
      self.adresse_tva        = adresse_l1_tva
      self.ville_tva          = adresse_localite_tva
      self.complement_tva     = etablissement_tva.adresse[:complement_adresse]
    end
  end

  def adresse_l1_tva
    [
      etablissement_tva.adresse[:numero_voie],
      etablissement_tva.adresse[:indice_repetition],
      etablissement_tva.adresse[:type_voie],
      etablissement_tva.adresse[:libelle_voie]
    ]
      .compact
      .join(' ')
  end

  def adresse_localite_tva
    etablissement_tva.adresse[:libelle_commune] || etablissement_tva.adresse[:libelle_commune_etranger]
  end

  def no_successor_attributes_set_for_groupe_is_if_false
    if !groupe_is? && membre_is
      errors.add(:membre_is, 'incoherent value since groupe_is is false')
    end
  end

  def no_successor_attributes_set_for_groupe_tva_if_false
    if !groupe_tva? && membre_tva
      errors.add(:membre_tva, 'incoherent value since groupe_tva is false')
    end
  end

  def no_successor_attributes_set_for_membre_is_if_mere
    if groupe_is? && membre_is == 'MERE'
      errors.add(:code_postal_is, 'cannot be set if membre_is is set to MERE') unless code_postal_is.nil?
      errors.add(:raison_sociale_is, 'cannot be set if membre_is is set to MERE') unless raison_sociale_is.nil?
      errors.add(:adresse_is, 'cannot be set if membre_is is set to MERE') unless adresse_is.nil?
      errors.add(:ville_is, 'cannot be set if membre_is is set to MERE') unless ville_is.nil?
      errors.add(:complement_is, 'cannot be set if membre_is is set to MERE') unless complement_is.nil?
    end
  end

  def must_have_successor_attributes_set_for_membre_is_if_fille
    if groupe_is? && membre_is == 'FILLE'
      errors.add(:code_postal_is, 'cannot be nil if membre_is is set to FILLE') if code_postal_is.nil?
      errors.add(:raison_sociale_is, 'cannot be nil if membre_is is set to FILLE') if raison_sociale_is.nil?
      errors.add(:adresse_is, 'cannot be nil if membre_is is set to FILLE') if adresse_is.nil?
      errors.add(:ville_is, 'cannot be nil if membre_is is set to FILLE') if ville_is.nil?
    end
  end

  def no_successor_attributes_set_for_membre_tva_if_mere
    if groupe_tva? && membre_tva == 'MERE'
      errors.add(:code_postal_tva, 'cannot be set if membre_tva is set to MERE') unless code_postal_tva.nil?
      errors.add(:raison_sociale_tva, 'cannot be set if membre_tva is set to MERE') unless raison_sociale_tva.nil?
      errors.add(:adresse_tva, 'cannot be set if membre_tva is set to MERE') unless adresse_tva.nil?
      errors.add(:ville_tva, 'cannot be set if membre_tva is set to MERE') unless ville_tva.nil?
      errors.add(:complement_tva, 'cannot be set if membre_tva is set to MERE') unless complement_tva.nil?
    end
  end

  def must_have_successor_attributes_set_for_membre_tva_if_fille
    if groupe_tva? && membre_tva == 'FILLE'
      errors.add(:code_postal_tva, 'cannot be nil if membre_tva is set to FILLE') if code_postal_tva.nil?
      errors.add(:raison_sociale_tva, 'cannot be nil if membre_tva is set to FILLE') if raison_sociale_tva.nil?
      errors.add(:adresse_tva, 'cannot be nil if membre_tva is set to FILLE') if adresse_tva.nil?
      errors.add(:ville_tva, 'cannot be nil if membre_tva is set to FILLE') if ville_tva.nil?
    end
  end
end
