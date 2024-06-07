class CNAV::ValidateNomNaissance < ValidateParamInteractor
  def call
    invalid_param!(:family_name) unless valid_nom_naissance?
  end

  private

  def valid_nom_naissance?
    !param(:nom_naissance).nil?
  end
end
