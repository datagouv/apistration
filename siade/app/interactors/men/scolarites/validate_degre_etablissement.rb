class MEN::Scolarites::ValidateDegreEtablissement < ValidateParamInteractor
  VALID_VALUES = %w[1D 2D].freeze

  raises UnprocessableEntityError, field: :degre_etablissement

  def call
    invalid_param!(:degre_etablissement) unless VALID_VALUES.include?(param(:degre_etablissement))
  end
end
