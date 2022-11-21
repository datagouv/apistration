class APIEntreprise::MI::AssociationSerializer::V3 < APIEntreprise::V3AndMore::BaseSerializer
  attributes :siret,
    :adresse_siege

  attribute :rna_id do |object|
    object.identite[:id_rna]
  end

  attribute :titre do |object|
    object.identite[:nom]
  end

  attribute :objet do |object|
    object.activites[:objet]
  end

  attribute :siret_siege_social do |object|
    object.identite[:id_siret_siege]
  end

  attribute :date_creation do |object|
    object.identite[:date_creat]
  end

  attribute :date_declaration do |object|
    object.identite[:date_modif_rna]
  end

  attribute :date_publication do |object|
    object.identite[:date_pub_jo]
  end

  attribute :date_dissolution do |object|
    object.identite[:date_dissolution]
  end

  attribute :etat do |object|
    object.identite[:active]
  end

  attribute :groupement do |object|
    object.identite[:groupement]
  end

  attribute :mise_a_jour do |object|
    object.identite[:date_modif_rna]
  end
end
