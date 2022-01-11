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
      nom: nom(item),
      status: status(item),
      depositaire: depositaire(item),
      clef: clef(item),
      notice: notice(item)
    }
  end

  private

  def latest_marques
    json_body['results'].first(limit)
  end

  def id_number(item)
    find_field_from_key(item, 'ApplicationNumber')['value']
  end

  def nom(item)
    find_field_from_key(item, 'Mark')['value']
  end

  def status(item)
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

  def notice(item)
    item['xml']['href']
  end

  def limit
    context.params[:limit]
  end
end
