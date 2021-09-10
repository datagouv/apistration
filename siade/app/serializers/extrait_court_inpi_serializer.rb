class ExtraitCourtINPISerializer < ActiveModel::Serializer
  attribute :brevets
  attribute :modeles
  attribute :marques

  def brevets
    {
      count: object.count_brevets,
      latests_brevets: object.latests_brevets
    }
  end

  def modeles
    {
      count: object.count_modeles,
      latests_modeles: object.latests_modeles
    }
  end

  def marques
    {
      count: object.count_marques,
      latests_marques: object.latests_marques
    }
  end
end
