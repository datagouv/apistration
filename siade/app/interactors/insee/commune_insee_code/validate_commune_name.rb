class INSEE::CommuneINSEECode::ValidateCommuneName < ValidateAttributePresence
  raises UnprocessableEntityError, field: :nom_commune_naissance

  def attribute
    :nom_commune_naissance
  end
end
