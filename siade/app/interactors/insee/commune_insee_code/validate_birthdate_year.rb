class INSEE::CommuneINSEECode::ValidateBirthdateYear < ValidateParamInteractor
  include YearValidation

  raises UnprocessableEntityError, field: :annee_date_naissance

  def year_param_name
    :annee_date_naissance
  end
end
