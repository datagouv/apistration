class Infogreffe::PersonnesMoralesSerializer::V3 < JSONAPI::BaseSerializer
  set_type :personne_morale

  attributes :id,
    :fonction,
    :raison_sociale,
    :code_greffe,
    :libelle_greffe,
    :identifiant
end
