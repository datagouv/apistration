class MEN::Scolarites::ValidateDegreEtablissement < ValidateParamInteractor
  VALID_VALUES = %w[1D 2D].freeze

  def call
    invalid_param!(:degre_etablissement) unless VALID_VALUES.include?(param(:degre_etablissement))
  end
end
