class Douanes::EORI::BuildResource < BuildResource

  protected

  def resource_attributes
    {
      id: infos_eori['identifiant'],
      actif: infos_eori['actif'],
      code_pays: infos_eori['codePays'],
      code_postal: infos_eori['codePostal'],
      raison_sociale: infos_eori['libelle'],
      pays: infos_eori['pays'],
      rue: infos_eori['rue'],
      ville: infos_eori['ville']
    }
  end

  private

  def infos_eori
    json_body['EORI']
  end
end
