class CNAV::FoyerRSA::BuildResource < BuildResource
  protected

  def resource_attributes
    {
      beneficiaires: foyer['beneficiaire'].map { |beneficiaire| build_beneficiaire(beneficiaire) },
      personnes_a_charge: Array(foyer['personnesaCharge']).map { |personne| build_personne(personne) }
    }
  end

  private

  def foyer
    json_body['foyer']
  end

  def build_beneficiaire(beneficiaire)
    build_personne(beneficiaire).merge(qualite: beneficiaire['qualite']&.downcase)
  end

  def build_personne(personne)
    {
      nom_naissance: personne['nomNaissance'],
      nom_usage: personne['nomUsage'].presence,
      prenoms: personne['listePrenoms'],
      date_naissance: personne['dateNaissance'],
      sexe: personne['genre']
    }
  end
end
