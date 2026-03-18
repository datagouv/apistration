class EORIDouanesSerializer < ActiveModel::Serializer
  attributes :numero_eori, :actif, :raison_sociale, :rue, :ville, :code_postal, :pays, :code_pays
end
