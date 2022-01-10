class INPI::Marques::BuildResourceCollection < BuildResourceCollection
  protected

  def items
    latest_marques
  end

  def items_meta
    {
      count: json_body['metadata']['count']
    }
  end

  def resource_attributes(item)
    {
      id: id_number(item),
      marque: marque(item),
      marque_status: marque_status(item),
      depositaire: depositaire(item),
      clef: clef(item)
    }
  end

  private

  def latest_marques
    json_body['results'].first(limit)
  end

  def id_number(item)
    find_field_from_key(item, 'ApplicationNumber')['value']
  end

  def marque(item)
    find_field_from_key(item, 'Mark')['value']
  end

  def marque_status(item)
    find_field_from_key(item, 'MarkCurrentStatusCode')['value']
  end

  def depositaire(item)
    find_field_from_key(item, 'DEPOSANT')['value']
  end

  def clef(item)
    find_field_from_key(item, 'ukey')['value']
  end

  def find_field_from_key(item, key)
    item['fields'].find { |f| f['name'] == key }
  end

  def limit
    context.params[:limit]
  end
end
