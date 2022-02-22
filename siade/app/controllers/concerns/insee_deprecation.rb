module INSEEDeprecation
  def deprecation_error(kind)
    error_json(GoneError.new('INSEE', deprecation_error_message(kind)), status: 410)
  end

  def deprecation_error_message(kind)
    if kind == :etablissement
      'Les anciennes API de l\'INSEE ont été décomissionnées et cet endpoint n\'est plus disponible. Merci d\'appeler /v2/etablissements/ comme indiqué dans la documentation https://entreprise.api.gouv.fr/catalogue/#etablissements pour obtenir les informations d\'un établissement.'
    else
      'Les anciennes API de l\'INSEE ont été décomissionnées et cet endpoint n\'est plus disponible. Merci d\'appeler /v2/entreprises/ comme indiqué dans la documentation https://entreprise.api.gouv.fr/catalogue/#entreprises pour obtenir les informations d\'une entreprise.'
    end
  end
end
