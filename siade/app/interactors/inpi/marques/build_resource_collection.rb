class INPI::Marques::BuildResourceCollection < BuildResourceCollection
  include INPI::ResourceHelpers

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
      notice_url: notice_url(item)
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

  def notice_url(item)
    item['xml']['href']
  end
end
