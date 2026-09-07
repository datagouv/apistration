class INSEE::CommuneINSEECode::ValidateBirthdateYear < ValidateYear
  raises UnprocessableEntityError, field: :annee_date_naissance
  never_raises UnprocessableEntityError, field: :year

  def year_param_name
    :annee_date_naissance
  end
end
