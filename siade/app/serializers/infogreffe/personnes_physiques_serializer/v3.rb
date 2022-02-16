class Infogreffe::PersonnesPhysiquesSerializer::V3 < JSONAPI::BaseSerializer
  set_type :personne_physique

  attributes :fonction,
    :nom,
    :prenom,
    :date_naissance,
    :date_naissance_timestamp,
    :lieu_naissance,
    :pays_naissance,
    :code_pays_naissance,
    :nationalite,
    :code_nationalite
end
