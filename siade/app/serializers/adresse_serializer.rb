class AdresseSerializer < V3AndMore::BaseSerializer
  set_type :adresse

  attributes :numero_voie,
    :indice_repetition_voie,
    :type_voie,
    :libelle_voie,
    :complement,
    :code_postal,
    :commune,
    :departement,
    :region
end
