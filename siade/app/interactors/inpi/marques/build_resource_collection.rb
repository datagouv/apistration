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
    @item = item

    {
      id: id_number,
      marque: marque,
      marque_status: marque_status,
      depositaire: depositaire,
      clef: clef
    }
  end

  private

  def latest_marques
    json_body['results'].first(limit)
  end

  def fields
    @fields ||= @item['fields']
  end

  def id_number
    find_field_from_key('ApplicationNumber')['value']
  end

  def marque
    find_field_from_key('Mark')['value']
  end

  def marque_status
    find_field_from_key('MarkCurrentStatusCode')['value']
  end

  def depositaire
    find_field_from_key('DEPOSANT')['value']
  end

  def clef
    find_field_from_key('ukey')['value']
  end

  def find_field_from_key(key)
    fields.find { |f| f['name'] == key }
  end

  def limit
    context.params[:limit]
  end
end
