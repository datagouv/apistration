class APIEntreprise::MI::AssociationSerializer::V3 < APIEntreprise::V3AndMore::BaseSerializer
  attributes :siret,
    :adresse_siege

  attribute :rna_id do |object|
    object.identite[:rna]
  end

  attribute :titre do |object|
    object.identite[:nom]
  end

  attribute :objet do |object|
    object.activites[:objet]
  end

  attribute :siret_siege_social do |object|
    object.identite[:siret_siege]
  end

  attribute :date_creation do |object|
    object.identite[:date_creation_rna]
  end

  attribute :date_declaration do |object|
    object.identite[:date_derniere_mise_a_jour_rna]
  end

  attribute :date_publication do |object|
    object.identite[:date_publication_journal_officiel]
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
    object.identite[:date_derniere_mise_a_jour_rna]
  end
end
