class DGFIP::ChiffresAffairesSerializer::V3 < V3AndMore::BaseSerializer
  set_type :exercice

  attributes :chiffre_affaires,
    :date_fin_exercice
end
