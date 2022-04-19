class DGFIP::ChiffresAffaires::BuildResource < BuildResourceCollection
  protected

  def items
    json_body['liste_ca']
  end

  def resource_attributes(item)
    {
      date_fin_exercice: build_date(item),
      chiffre_affaires: item['ca'].to_i
    }
  end

  def items_meta
    {
      count: items.count
    }
  end

  private

  def build_date(item)
    Date.parse(item['dateFinExercice']).to_s
  end
end
