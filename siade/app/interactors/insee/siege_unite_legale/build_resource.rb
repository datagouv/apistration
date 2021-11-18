class INSEE::SiegeUniteLegale::BuildResource < INSEE::Etablissement::BuildResource
  protected

  def etablissement
    @etablissement ||= json_body['etablissements'][0]
  end
end
