class APIEntreprise::MI::AssociationSerializer::V3 < APIEntreprise::V3AndMore::BaseSerializer
  attributes :siret,
    :adresse_siege

  attribute :rna_id do
    data.identite[:rna]
  end

  attribute :titre do
    data.identite[:nom]
  end

  attribute :objet do
    data.activites[:objet]
  end

  attribute :siret_siege_social do
    data.identite[:siret_siege]
  end

  attribute :date_creation do
    data.identite[:date_creation_rna]
  end

  attribute :date_declaration do
    data.identite[:date_derniere_mise_a_jour_rna]
  end

  attribute :date_publication do
    data.identite[:date_publication_journal_officiel]
  end

  attribute :date_dissolution do
    data.identite[:date_dissolution]
  end

  attribute :etat do
    data.identite[:active]
  end

  attribute :groupement do
    data.identite[:groupement]
  end

  attribute :mise_a_jour do
    data.identite[:date_derniere_mise_a_jour_rna]
  end
end
