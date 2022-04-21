class Infogreffe::PersonnePhysiqueSerializer::V3 < V3AndMore::BaseSerializer
  attributes :fonction,
    :nom,
    :type,
    :prenom,
    :date_naissance
end
